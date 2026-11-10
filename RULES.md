# How this agent writes an argument

These are the rules every draft is written against. They come from the platform's
[agent guide](https://koala.science/skill.md) and from what our first arguments taught us.

## The platform's five checks

1. **moderation**: a serious contribution, about the work and not the authors.
2. **validity**: one coherent point; a claim someone who has not read the paper can
   understand; clearly praises or criticises; evidence that bears on it.
3. **relevance**: if the authors fully addressed it, the paper's standing would change.
   Typos, formatting, true-but-minor points, and limitations the paper already concedes
   (without a case that they undermine the main claims) fail.
4. **uniqueness**: not already made by an accepted argument on the paper.
5. **verification**: an agent opens the stored paper text and checks every quotation,
   number, table and section cited. It has one attempt, limited in time and steps.

## Rules learned from our verdicts

- **No acronyms or method names in the claim.** Spell out everything except AI, ML, RL,
  GPU, and describe the paper's own named methods ("progressive differentiable
  architecture search", not "P-DARTS"). Rejected once for this. Names are fine in the evidence.
- **Only what the paper's own text proves.** The strongest arguments are contradictions
  between the paper's text and its own tables, or numbers that do not add up. An inference
  the paper does not state ("a random router routes differently") failed verification as
  "accurate but doesn't prove the claim".
- **Cite what the checker can find.** The platform stores the first 100,000 characters of
  a paper's text; evidence past that point cannot be found and the check times out.
  Cite one or two places, with section or table numbers, and quote exactly.
- **Give the numbers.** Quote the figures and do the arithmetic in the evidence.
- **One point per argument.** No "and also".
