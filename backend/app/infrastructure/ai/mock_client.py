import time
from app.infrastructure.ai.llm_client import LLMClient

class MockLLMClient(LLMClient):
    """
    A mock implementation of the LLMClient for Phase 6A demo purposes.
    Simulates network latency and returns realistic dummy data.
    """
    
    def generate_meeting_summary(self, notes_content: str) -> str:
        time.sleep(1.5)  # Simulate network latency
        
        return """### Meeting Summary

Based on the notes, the meeting focused on aligning enterprise requirements and exploring connectivity solutions. Both parties expressed interest in moving forward.

**Key Discussion Points:**
* Reviewed current infrastructure bottlenecks.
* Discussed Airtel's dedicated leased line options.
* Addressed security and compliance requirements.

**Decisions Made:**
* Proceed with a 30-day proof-of-concept (POC).
* Schedule a follow-up technical deep-dive next week.
"""

    def extract_action_items(self, notes_content: str) -> list[str]:
        time.sleep(1.0)
        
        return [
            "Send updated pricing proposal for the enterprise leased line (Sales Team).",
            "Provide technical documentation on network security compliance (Sales Engineering).",
            "Schedule technical deep-dive meeting for next Tuesday (Account Manager).",
            "Share current bandwidth utilization reports (Customer IT Team)."
        ]

    def draft_follow_up_email(self, customer_name: str, meeting_title: str, notes_content: str) -> str:
        time.sleep(2.0)
        
        return f"""Subject: Follow-up: {meeting_title}

Hi Team,

Thank you for your time today to discuss your enterprise requirements. It was great learning more about {customer_name}'s current setup and future goals.

As discussed, we are excited to propose a 30-day proof-of-concept for our connectivity solutions to address the bottlenecks we identified.

**Next Steps:**
1. I will send over the updated pricing proposal by tomorrow.
2. Our engineering team will share the requested security compliance documentation.
3. We will schedule a technical deep-dive for next Tuesday.

Please let me know if you have any immediate questions in the meantime.

Best regards,

[Your Name]
Airtel Enterprise Sales
"""

    def generate_customer_insights(self, context_data: str) -> str:
        time.sleep(2.0)
        
        return """### Customer Insights

**Relationship Summary:**
The relationship with this customer is actively developing. They have shown strong interest in upgrading their enterprise connectivity and are currently evaluating our dedicated leased line solutions.

**Outstanding Commitments:**
* Deliver an updated pricing proposal for the enterprise leased line.
* Provide technical documentation regarding network security compliance.
* Set up a technical deep-dive meeting next Tuesday.

**Next Recommended Actions:**
1. Follow up on the pricing proposal to ensure alignment with their budget.
2. Prepare the engineering team for the deep-dive to address any remaining technical roadblocks.
3. Check in on the status of the 30-day proof-of-concept (POC) setup.

**Risk Indicators:**
* **Moderate Risk**: Delays in providing security documentation could stall the POC approval process.
* **Low Risk**: Competitor pricing might become a factor if our proposal exceeds expectations without clear ROI justification.
"""
