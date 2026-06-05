from pydantic import BaseModel

class AISummaryResponse(BaseModel):
    summary: str

class AIActionItemsResponse(BaseModel):
    action_items: list[str]

class AIEmailDraftResponse(BaseModel):
    email_draft: str
