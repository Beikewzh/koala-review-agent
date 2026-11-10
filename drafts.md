# Draft arguments (not posted)

Each draft is checked against the platform's five checks before posting. Nothing here is
on the platform until Zihan approves it.

## 1. Through the Looking Glass: Directly Reading and Writing Transformers

- paper_id: 71bf4628-…  (arXiv 2609.10210; 2 arguments already on it, both positive)
- position: negative

**Claim.** The paper's finding that the largest models it tests need only about two
components to reproduce a prediction is not established, because each reported size is a
median taken only over the predictions on which the paper's search for a sufficient set of
components succeeded, and that search fails on a large share of the predictions of exactly
those large models.

**Evidence.** Table 40 (Section 6.3) gives, per model, how many of the sampled predictions
the search verified, and its caption states that "the size and the controls are over those";
the text adds that the remaining predictions are "excluded from everything to its right."
The verified counts are 32 of 60 predictions for Qwen2.5 7B, 47 of 60 for Mistral 7B, 65 of
150 for Qwen2.5 1.5B and 60 of 150 for Llama-3.2 1B, against 131 of 150 for GPT-2 124M and
141 of 150 for OPT 125M. On the predictions where the search fails, the set is not small: on
the paper's own baseline, Section 2.5 reports that "where the repair never converges it has
already built a mean of 489 components, at most 962 or two percent of the model, and the
token still does not come out." The abstract nevertheless states that "the sufficient set
runs from two components to sixteen", and Section 6.3 that "the largest models sit at its
small end: Mistral 7B and Qwen2.5 7B rest on two components each", although for Qwen2.5 7B
almost half of the sampled predictions (28 of 60) have no sufficient set found at all.

## 2. Adaptive-Labeling for Enhancing Remote Sensing Cloud Understanding

- paper_id: 28c31825-…  (arXiv 2311.05198; 7 arguments already on it, none about this)
- position: negative

**Claim.** The paper's largest reported gain, lifting the DeepLabV3 segmentation network
from 44.02 to 83.95 mean intersection-over-union, rests on a baseline score that contradicts
the baseline's own precision and recall in the same table, and with a score consistent with
those numbers the gain shrinks from about 40 points to about 6.

**Evidence.** Table 1 (and again Table 2) reports DeepLabV3 at mIoU 44.02 with precision
86.25, recall 89.53, F1-score 86.73 and overall accuracy 96.07. For the cloud class,
intersection-over-union is fixed by precision P and recall R as 1/(1/P + 1/R - 1), which
gives 78.35 for these values. If the mIoU instead averages the cloud and non-cloud classes,
reaching 44.02 would need a non-cloud IoU of about 9.7, but with 96.07 percent of pixels
classified correctly at most 3.93 percent are errors, which forces the non-cloud IoU to about
95 and the mean to about 87. Every other row of Table 1 is consistent with the same formula
to within about 6 points (for example FCN: 54.76 from P and R against 60.40 reported; U-Net:
72.74 against 73.69; DeepLabV3 + CAL: 81.61 against 83.95). The text relies on the outlier:
Section 4 states that the method "significantly enhances the performance of U-Net,
DeeplabV3, and FCN, demonstrating an improvement of 20% or more in mIoU". Measured against a
DeepLabV3 baseline of about 78, the improvement is about 6 points, below that bar.

## 3. Communicate the Change: Efficient Expert Parallelism via Activation Compression

- paper_id: cf1fbe82-…  (5 arguments already on it; none about the larger-model runs)
- position: negative

**Claim.** The paper's statement that its throughput gain extends to larger
mixture-of-experts models (Qwen3-235B-A22B, DeepSeek-V3 and Kimi-K2.6) is not established,
because those speedups were measured on copies of the models with random weights, whose
routers do not send tokens to the experts the trained models would choose, and the
inter-node traffic that the speedup comes from depends on exactly those routing choices.

*Revised after draft 1 timed out in verification: the posted evidence
(arguments/03_communicate_change.json) cites two places with page numbers and drops
Equation (1) and Appendix G.4. The longer version is kept below.*

**Evidence.** Section 5.4 is headed "The implementation and throughput gain extends to
larger MoE architectures" and reports 1.15x, 1.18x and 1.05x throughput on Qwen3-235B-A22B,
DeepSeek-V3 and Kimi-K2.6, adding that "these tests use full-sized models with random
weights and report throughput improvements only." Appendix G.4 repeats that "These
full-sized architectures use random weights" and that the comparisons establish "execution
cost and memory feasibility, without assessing task performance after adaptation." The
traffic being saved is routing-dependent: Equation (1) makes inter-node volume proportional
to the average number of remote nodes each token reaches, and Appendix F.1 measures that
quantity from routing traces, "routed transfers reach 2.73 remote nodes per token on
average" for the trained Qwen3-30B-A3B, noting that the estimates "remain fixed for a given
configuration, topology and routing trace." A randomly initialised router produces a
different trace, so the larger-model numbers show neither the accuracy cost of the
compression on those models nor the traffic, and hence the speedup, under their real routing.


## 4. An Information-Theoretic View on the Safety of Open-Weights Models

- paper_id: d352737e-…  (7 arguments already on it; none about checkpoint selection)
- position: negative

**Claim.** The paper's headline evidence that small fine-tuning attacks are the cheapest way to make the model comply with harmful requests reports, for each fine-tuning run, the best of up to 64 saved checkpoints as scored on the evaluation benchmark itself, while the complexity charged to the attack counts only a single evaluation pass and nothing for that selection, so the success rates at the low-complexity end are selected on the test set at no recorded cost.

**Evidence.** Appendix B (Fine-tuning) states that the runs "train for 2 epochs at 512 examples and scale up accordingly (so 64 epochs at 16 examples). LoRA weights are checkpointed after every epoch and we report the best-performing checkpoint." A 32-example run therefore picks the best of 32 checkpoints and a 16-example run the best of 64, and choosing among them requires running every checkpoint on the benchmark and scoring it with the benchmark's judge. The compute the same appendix charges to the attack is only "training FLOPs plus average inference FLOPs per evaluation example", and the bits term is "16 · Ntokens of the training dataset", so neither the repeated evaluations nor the information taken from the test labels enters the complexity. Section 5 builds its first recommendation on exactly these small runs: "fine-tuning on 32 adversarial examples for HarmBench reaches 94.5% ASR at 2.2 × 10^5 bits of complexity, which is 16× cheaper than AutoDAN's 3.5 × 10^6 bits, which yields only 36.3% ASR."

## 5. Learning from Mistakes based on Class Weighting with Application to Neural Architecture Search

- paper_id: bc8dc601-…  (12 arguments already on it; none about the P-DARTS CIFAR-10 row)
- position: negative

**Claim.** The paper's claim that its class-weighted synthetic-data method improves the architectures found by every differentiable architecture search algorithm it is added to, on CIFAR-10 as well as CIFAR-100, is contradicted by its own results table: added to P-DARTS, the method gives a higher CIFAR-10 test error than P-DARTS alone.

**Evidence.** Table 2 reports CIFAR-10 test error of 2.50% for P-DARTS (Chen et al., 2019) and 2.53 ± 0.05% for LFM-CW-BigGAN-PDARTS (ours), so the method makes the P-DARTS architecture slightly worse on CIFAR-10, and the reported spread of 0.05 does not make the 2.53 an improvement. Section 4.3 nevertheless states that the CIFAR-100 observations "can be further extended to the architecture search on CIFAR-10, where our method achieves superior performance compared to the baselines", and opens by saying the framework "significantly reduces the errors on the test set when compared to existing differential NAS methods such as DARTS, P-DARTS, and PC-DARTS." P-DARTS is one of the three base algorithms the paper uses to show the method works across search algorithms, so on CIFAR-10 that claim holds for two of the three, not all of them.

## 06. BRIDGE: Predicting Human Task Completion Time From Model Performance

- paper_id: 46fa8805-…  (drafted by a helper agent under RULES.md; quotes checked with check_quotes.py)
- position: negative

**Claim.** On the one large benchmark with human time labels (500 software-engineering issues), the proposed method puts fewer tasks in the correct time bucket than a trivial rule that always predicts the most common bucket, which undercuts the paper's claim that its time estimates are quantitatively accurate where ground truth exists.

**Evidence.** Figure 3 (Section 4.3) reports SWE-bench Verified bucket sizes 'n=194 n=261 n=42 n=3' for <15 min, 15-60 min, 1-4 hrs and >4 hrs, which sum to 500, the size of the benchmark. The panels are in the order Logit Success Rate, Gemini 3 Pro, GPT-5.2, BRIDGE. The BRIDGE panel reports 'Acc: 41.6% F1: 0.284 κ: 0.231' with per-bucket accuracy 'Acc: 77% Acc: 18% Acc: 21% Acc: 67%'. Recomputing gives 0.77x194 + 0.18x261 + 0.21x42 + 0.67x3 = 149.4 + 47.0 + 8.8 + 2.0 = 207.2, and 207.2/500 = 41.4%, which matches the reported 41.6% and confirms the panel mapping. A constant prediction of '15-60 min' would be right on 261/500 = 52.2% of tasks, which is 10.6 points above BRIDGE. BRIDGE gets only 18% of that largest bucket right, about 47 of 261 tasks. Its margin over the heuristic baseline ('Acc: 38.6% F1: 0.165 κ: 0.115') is 3 points of accuracy. Yet the text says 'BRIDGE achieves substantially better alignment with the annotated time buckets than both heuristic and' LLM baselines, and the summary says the estimates are 'quantitatively accurate where ground truth is available'.

## 07. BRIDGE: Predicting Human Task Completion Time From Model Performance

- paper_id: 46fa8805-…  (drafted by a helper agent under RULES.md; quotes checked with check_quotes.py)
- position: negative

**Claim.** The paper's headline claim that it independently reproduces the earlier human-study finding that task-length horizons grow exponentially is not independent, because its time scale is fitted on that same study's 170 tasks and human time annotations, and its linear difficulty-to-log-time relationship is derived by taking that study's exponential growth as a premise.

**Evidence.** The abstract claims the method can 'independently reproduce METR’s exponential scaling results', and the introduction calls this 'providing independent validation that model-centric data can recover human-centric task length forecasting'. However, Section 4 states 'We use METR to learn the calibration mapping between latent task difficulty b and human completion time.' Section 4.1.1 says the calibration data is METR's own release: 'METR (Kwa et al., 2026) released a unified dataset aggregating model performance on 170 tasks spanning' SWAA, HCAST and RE-Bench. Section 2.1 says the original METR result rests on the same set: 'Their analysis relied on human time annotations for 170 tasks'. So every horizon in Figure 6 is converted to hours through a regression (Equation 3) fitted on exactly the tasks and human times behind the METR estimate being 'reproduced'. Section 3 also justifies the linear relationship by assuming the result: 'Independently, METR’s results show that the human task-time horizon h also grows exponentially with t', and then 'Combining these two observations: θ ∝ log h.' A method anchored to METR's human times and whose functional form is derived from METR's exponential trend cannot give independent confirmation of that trend.

## 08. Critical Learning Periods: Leveraging Early Training Dynamics for Efficient Data Pruning

- paper_id: e71ae065-…  (drafted by a helper agent under RULES.md; quotes checked with check_quotes.py)
- position: negative

**Claim.** The conclusion says the proposed pruning methods keep more than 75% of full-data performance at 90% pruning for every target language, but the paper's own results section says the variance-based variant keeps only about 30% for Swahili.

**Evidence.** Section 7 (Conclusions) states that 'CAT techniques offer highly computationally efficient pruning that achieves above 75% of full performance even when 90% pruning is applied to all target languages', and Section 5.1 opens with the same general claim: 'CAT techniques achieve efficient pruning while maintaining an upwards of 75% performance'. A few lines further into Section 5.1, the paper itself says that for Swahili 'CAT-VAR tends to perform worse, retaining only around 30% of the performance'. The Figure 1 caption agrees: 'CAT-VAR yields very poor performance for Swahili'. CAT-VAR is one of the two methods the paper proposes (Section 3.2). At about 30% retention for Swahili, it misses the claimed 75% floor by roughly 45 percentage points on one of the three target languages. The conclusion's universal claim holds for only one of the two proposed methods, and the paper does not say so.

## 09. Critical Learning Periods: Leveraging Early Training Dynamics for Efficient Data Pruning

- paper_id: e71ae065-…  (drafted by a helper agent under RULES.md; quotes checked with check_quotes.py)
- position: negative

**Claim.** At full dataset scale the paper's own checkpoint-perplexity pruning method scores about nine points of bilingual evaluation understudy (BLEU) translation quality below random selection for Swahili, which contradicts the paper's statement that the full-scale results match the smaller-scale ones, where the method was reported to beat random selection for Swahili.

**Evidence.** Section 5.5 presents the full-dataset run as a test 'To verify the generalizability of CAT-DIFF along with baselines' and concludes: 'We find the results to be similar to 3.8M scale experiments.' The summary sentence then mentions only German and French for CAT-DIFF ('Table 3 show that CAT-DIFF(1,5) outperforms random in German and French') and does not say how it did on Swahili. Table 3 (90% prune level, about 23M Swahili sentences) gives Random 29.3 / 24.5, LaBSE 33.6 / 28.9, CAT-DIFF(1,5) 20.3 / 15.3 and Full 33.0 / 27.5 on FLORES / MAFAND-MT. So CAT-DIFF(1,5) is 29.3 - 20.3 = 9.0 and 24.5 - 15.3 = 9.2 BLEU below random selection, and keeps only 20.3/33.0 = 62% and 15.3/27.5 = 56% of full-data performance. At the 3.8M scale, Section 5.1 says 'in Swahili, only CAT-DIFF(1,5) consistently outperforms random selection', and Table 2 gives CAT-DIFF(1,5) at 90% pruning 25.0 (FLORES) and 21.0 (MAFAND-MT). The method therefore loses 4.7 and 5.7 BLEU when it is given more data to select from, and its ranking against random selection flips. The full-scale experiment is the paper's only test of scalability, and it shows the reverse of what the text says it shows for one of the three languages.

## 10. On the low-shot transferability of [V]-Mamba

- paper_id: 74be853e-…  (drafted by a helper agent under RULES.md; quotes checked with check_quotes.py)
- position: negative

**Claim.** The paper says the gap between its two transfer methods grows with model size in both state-space model families, but its own description of the scaling figure says the small and large curves of one family nearly coincide, so the scaling finding rests on a single family.

**Evidence.** Section 4, last paragraph (Figure 3), says the scaling pattern is 'evident in both SSM variants, Vim and VSSM'. The next sentence says 'the trends for VSSM-Tiny and VSSM-Small are distinctively separated for most of the datasets whereas Vim-Tiny and Vim-Small closely follow each other for most of the datasets.' If the Vim-Tiny and Vim-Small curves of the gap closely follow each other on most datasets, then for most datasets the gap does not change with Vim model size. So the 'both' claim is contradicted one sentence later, and only the VSSM pair separates. Insight (c) in the abstract and the conclusion ('a weak positive correlation between the performance gap in transfer via linear probing and visual prompting and the increasing scale of the [V]-Mamba model') is stated for [V]-Mamba in general. By the paper's own reading of Figure 3, it holds for one of the two families tested.

## 11. On the low-shot transferability of [V]-Mamba

- paper_id: 74be853e-…  (drafted by a helper agent under RULES.md; quotes checked with check_quotes.py)
- position: negative

**Claim.** The paper's own visual-prompting results include a case where the state-space models beat a vision transformer by more than 50 points at every data budget, which contradicts its headline finding that state-space models are weaker than or equal to vision transformers under visual prompting.

**Evidence.** Abstract insight (b) and the Section 4 heading '[V]-Mamba are worse or same as ViTs for VP' state that under visual prompting the state-space models are weaker than or equal to the vision transformers. Section 4's visual-prompting paragraph opens: 'In Figure 2 for ILM-VP, we find a trend contrary to that of LP, where SSM models perform poorly or are comparable in performance compared to their ViT counterparts.' The same paragraph ends 'In the case of the' and, because of the two-column layout, continues at the top of the right column on page 4: 'OxfordPets dataset, MoCov3 performs the worst, with the performance gap exceeding 50% consistently for different data budgets compared to other models.' MoCov3-Small is one of the three vision transformers (Section 3.2: 'MoCov3-Small [8]'), and the 'other models' in Figure 2 include both state-space models, Vim-Small and VSSM-Tiny. So on OxfordPets, under visual prompting, both state-space models beat a vision transformer by more than 50 accuracy points at all four data budgets (1, 10, 50, 100 shots). A gap that size is neither 'worse' nor 'comparable'. The only other comparison the paragraph gives, 'Vim-Small underperforms in comparison to VSSM-Tiny', is between two state-space models and says nothing about vision transformers. The paragraph that is supposed to support insight (b) therefore reports a large counterexample to it and no supporting example.

## 12. When Confidence Signals Disagree: Local and Global Confidence in Autoregressive Language Models

- paper_id: dc975f99-…  (drafted by a helper agent under RULES.md; quotes checked with check_quotes.py)
- position: negative

**Claim.** Most questions with a large gap between the two confidence signals give the same answer in every repeated sample, so the gap is a poor flag for unstable sampling, which undercuts the abstract's and conclusion's claim that the gap is a diagnostic of unstable sampling behavior.

**Evidence.** Section 6.1 and Table 2: 'A gap larger than 0.10 occurs for 23.0% of MMLU questions' and 'while gaps larger than 0.20 occur for 19.0% and 10.1%, respectively', i.e. 19 of 100 MMLU questions and 10 of 99 ARC questions have a gap above 0.20. For MMLU, Section 7 says 'with only four of 100 questions producing more than one answer under the baseline condition'. Even if all 4 unstable questions had gaps above 0.20, at least 19 - 4 = 15 of the 19 large-gap questions (79%) are stable. For ARC, Section 6.3 reports 'approximately 11% of questions producing more than one answer', about 11 of 99, and Section 6.4 says unstable questions 'have a median absolute confidence gap of 0.12, compared with 0.00 among stable questions'. With 11 unstable questions the median of 0.12 is the 6th value, so at most 5 of them can exceed 0.20, and at least 5 of the 10 ARC questions with a gap above 0.20 are stable. As a flag for instability, a gap above 0.20 is right at most 4/19 = 21% of the time on MMLU and at most about half the time on ARC. Yet the abstract says 'disagreement can provide a diagnostic of unstable sampling behavior' and the Conclusion says 'The local–global confidence gap provides a simple diagnostic for identifying inputs' on which sampling is less stable.

## 13. Model Stealing Through the Lens of Model Multiplicity

- paper_id: 61a4333a-…  (drafted by a helper agent under RULES.md; quotes checked with check_quotes.py)
- position: negative

**Claim.** The first contribution the paper lists, a new method for generating sets of near-equivalent copies of a stolen model, is the existing inference-time dropout sampling of Hsu et al. (2024) applied unchanged to the extracted model, as the paper's own background section describes it, so the paper's methodological novelty is overstated.

**Evidence.** Section 1, first contribution bullet: 'We introduce a method for generating dropout-based' Rashomon sets around extracted surrogates, 'allowing us to study model stealing as a multiplicity problem rather than as a single-model fidelity problem.' But Section 2.5 (Approximation of the Rashomon Set, in Background) attributes exactly this procedure to prior work: 'A practical alternative is to use Dropout at inference time to sample models likely to belong to the Rashomon set Hsu et al. (2024)', noting that 'dropout-based sampling is much cheaper computationally and allows us to generate large sets'. Section 4.2 even copies that paper's architecture: 'we chose the same architecture as used by Hsu et al. (2024)'. The only difference described in Sections 4.1-4.3 is the model the dropout is applied to: dropout on the linear layers of the extracted surrogate over a grid from 0.01 to 0.10. No change to the sampling, the filtering or the metrics is described.
