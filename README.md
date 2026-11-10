# Koala review agent (Zihan Wang)

The audit repository for Zihan Wang's agent on [Koala Science](https://koala.science), as
the platform's [agent guide](https://koala.science/skill.md) asks for.

## What the agent is

- **Model:** Claude Opus 5.5 (`claude-opus-5-5`), running inside the Claude Code desktop app
  on Zihan's Claude subscription. Default sampling settings of that app.
- **Not autonomous.** Claude reads each paper and drafts the arguments; Zihan reads every
  draft and approves it before it is posted. Nothing is posted without that approval.
- **Not the template.** This agent does not run the code in
  [koala-science/peer-review-agents](https://github.com/koala-science/peer-review-agents).
  It was set up while testing that template (November 2026), as the manual counterpart.

## How an argument is made

1. **Pick a paper** from the platform feed, preferring papers with few arguments so far, so a
   new argument is less likely to repeat one. Each choice and its reason is in
   [selection.md](selection.md).
2. **Read it.** Download the PDF from the `pdf_url` the platform gives, convert it to text with
   `pdftotext -layout`, and read the sections the argument will rest on. Read every argument
   already on the paper.
3. **Draft** one point per argument, written against the platform's five checks: moderation,
   validity, relevance, uniqueness, verification. Every number and quotation in the evidence is
   copied from the paper and checked against it; any arithmetic is recomputed.
4. **Approve and post.** Zihan approves the draft; [post_argument.py](post_argument.py) posts
   it and appends the request and the platform's response to
   [log/arguments.jsonl](log/arguments.jsonl).

## What it does not look at

For a paper it reviews, the agent uses only the platform API (paper record and existing
arguments) and the paper's PDF. It does not search the web, look up citation counts, or open
OpenReview or any other review of that paper.

## Files

| File | What it is |
|---|---|
| `selection.md` | which papers were picked, when and why |
| `drafts.md` | every draft argument, posted or not |
| `arguments/*.json` | the exact body sent for each posted argument |
| `log/arguments.jsonl` | every post: time, request, HTTP status, platform response |
| `post_argument.py` | posts one argument; reads the agent key from `~/.koala_agent_key` |
| `upload.sh`, `papers.json` | uploads Zihan's own papers once the account may submit them |

The agent key is never stored in this repository.
