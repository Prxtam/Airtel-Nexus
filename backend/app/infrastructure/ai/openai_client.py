import os
from app.infrastructure.ai.llm_client import LLMClient

try:
    from openai import OpenAI
except ImportError:
    OpenAI = None


class OpenAIClient(LLMClient):
    """
    Production-ready implementation of the LLMClient using OpenAI.
    Requires OPENAI_API_KEY environment variable.
    """

    def __init__(self):
        if OpenAI is None:
            raise RuntimeError("The 'openai' package is not installed. Run `pip install openai` to use the OpenAIClient.")
        
        api_key = os.environ.get("OPENAI_API_KEY")
        if not api_key:
            raise ValueError("OPENAI_API_KEY environment variable is not set. Cannot initialize OpenAIClient.")
            
        self.client = OpenAI(api_key=api_key)
        self.model = "gpt-4o-mini" # Fast, cost-effective default

    def _call_llm(self, system_prompt: str, user_prompt: str) -> str:
        response = self.client.chat.completions.create(
            model=self.model,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            temperature=0.3,
        )
        return response.choices[0].message.content

    def generate_meeting_summary(self, notes_content: str) -> str:
        system = (
            "You are an expert B2B Sales Assistant. Your task is to summarize meeting notes. "
            "Output must be in Markdown format. "
            "Include 3 sections: a short overview, 'Key Discussion Points' (bulleted list), "
            "and 'Decisions Made' (bulleted list)."
        )
        user = f"Here are the meeting notes:\n\n{notes_content}"
        return self._call_llm(system, user)

    def extract_action_items(self, notes_content: str) -> list[str]:
        system = (
            "You are an expert B2B Sales Assistant. Extract all actionable follow-up items from the meeting notes. "
            "If ownership is implied, include it in parentheses, e.g., 'Send proposal (Sales Team)'. "
            "Return ONLY a numbered list of action items, one per line. Do not include introductory text."
        )
        user = f"Here are the meeting notes:\n\n{notes_content}"
        response_text = self._call_llm(system, user)
        
        # Parse the numbered list back into a Python list
        lines = response_text.strip().split("\n")
        items = []
        for line in lines:
            line = line.strip()
            # Remove leading numbers/bullets (e.g., "1. ", "- ", "* ")
            if line and line[0].isdigit() and len(line) > 2 and line[1] in (".", ")"):
                items.append(line[2:].strip())
            elif line.startswith("- ") or line.startswith("* "):
                items.append(line[2:].strip())
            elif line:
                items.append(line)
                
        return items

    def draft_follow_up_email(self, customer_name: str, meeting_title: str, notes_content: str) -> str:
        system = (
            "You are an expert B2B Sales Account Manager. Write a professional, concise follow-up email "
            "based on the provided meeting notes. Do not invent details not present in the notes. "
            "Include a 'Next Steps' section if applicable. Use placeholders like [Your Name] for the signature."
        )
        user = (
            f"Customer: {customer_name}\n"
            f"Meeting Title: {meeting_title}\n"
            f"Meeting Notes:\n{notes_content}\n\n"
            f"Please draft the follow-up email."
        )
        return self._call_llm(system, user)
