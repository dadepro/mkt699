# MKT 699 — Empirical Methods in Marketing

**Professor:** Davide Proserpio (first half) and Guangying Chen (second half)
**Email:** proserpi@usc.edu, guangying.chen@marshall.usc.edu

**Office hours:** TBD

**Course website:** TBD

## Class Hours and Locations

**Wednesdays, 1:00–4:00 pm.** First meeting August 26, 2026. Room TBD.

The first half (weeks 1–7, Professor Proserpio) runs August 26 through October 7. The
second half (weeks 8–15, Professor Chen) runs October 14 through December 2.

## Course Description

This course provides PhD students with the toolkit for conducting rigorous empirical research in marketing. Through lectures, readings of classic and modern papers, and hands-on coding, students learn to identify research questions, choose appropriate empirical methods, and conduct replicable analyses from data to interpretation.

The class is taught in two equal parts. **The first part focuses on empirical research workflows in the age of large language models.** Two things have changed since this course was last offered. First, the marginal cost of writing code, cleaning data, and producing a regression table has collapsed. The binding constraint on empirical research is no longer execution; it is judgment, knowing what analysis to run, whether the output is correct, and whether the resulting claim is credible. Second, LLMs have become research instruments in their own right: they are used to measure constructs from unstructured data, to simulate respondents, and to automate parts of the research pipeline. Each use introduces statistical problems that do not appear in standard econometrics training. The first half of this course therefore covers reproducible and AI-assisted research workflows, the econometrics of working with AI-generated variables, and the design of credible research when analysis is cheap and verification is expensive.

The second part focuses on the fundamentals of structural analysis, particularly choice modeling in empirical industrial organization and marketing. These models bridge economic theory and empirical data, allowing researchers to estimate policy-invariant primitive parameters that are not directly observable and to evaluate counterfactual policies. This course emphasizes empirical data handling, model construction, and estimation challenges in applied research. We provide opportunities for you to "get your hands dirty" with data and estimation. At the end, we aim to expose you to classic and modern papers in choice modeling, help you become comfortable reading them, and prepare you to apply canonical methods in your own research.

This is a PhD-level, research-oriented class, intense and fast-paced. There is no set book for this course and students will be required to read and digest up to 4 research papers per week. In the first half, papers are reviewed through instructor-led discussion, and every student is expected to have read them and to participate. In the second half, papers are pre-assigned to students who present them to the class. These will be accompanied by a portion of lecture and applied analysis. Students will be required to program in R and Python.

While prior programming language experience is not required for this course, you are expected to do a large amount of work on your own to learn and own the tools we will use in this class.

Each half of the course will be evaluated by the respective instructors. The final grade will be an average of the two halves.

Please bring your laptops to class. This will be a very hands-on course. We'll be working through lecture notes together in class, and you'll be running code on your own machines.

### Course Objectives

Upon successful completion of this course, students will be able to:

1. Manage empirical research projects so that they are reproducible by others, and by themselves in two years
2. Use AI coding assistants productively while retaining the ability to verify what they produce
3. Understand the statistical consequences of using AI-generated variables in downstream inference, and apply the available corrections
4. Evaluate the credibility of empirical claims, including their own, and recognize the specification-search problems that cheap analysis makes worse
5. Understand the basics of structural estimation of choice models
6. Apply canonical static choice models in empirical research
7. Program in R and Python to replicate models, apply estimation methodologies, and implement evaluation criteria

---

## Lecture Outline (First Half)

The first half of the course is organized around a single premise: when producing an analysis becomes nearly free, the scarce skill becomes knowing whether the analysis is right. Weeks 1–3 build a working research infrastructure and an honest account of what AI tools do and do not do well. Weeks 4–5 cover the econometrics of measurement with LLMs, which is the methodological core of this half and the part most directly usable in your dissertation. Week 6 turns to research design and credibility. Week 7 is devoted to project presentations.

Every student will carry a **semester-long research project** through the first seven weeks, presented in Week 7. Details follow the weekly outline.

There is no set book for this section of the course. The lecture slides are detailed and self-contained. Relevant online references will be used as required.

### Week 1 — Reproducible Research Infrastructure

- Course overview; the project
- What changed: the collapsing cost of analysis and its consequences for research practice
- Project organization, version control with Git and GitHub, and why reproducibility became *harder*, not easier, with AI assistance
- The shell, remote computing, and USC/Marshall computing resources
- Environment management and dependency pinning: `renv` for R, `uv` for Python, so an analysis still runs in two years. Containers in brief
- Setting up an AI-assisted workflow: Claude Code, Codex, Cursor, and the API

*In-class lab: initialize your project repository. Every subsequent deliverable lives in it.*

### Week 2 — AI-Assisted Analysis and the Verification Problem

- Working with AI coding assistants on real research tasks: data cleaning, merges, panel construction, table and figure generation
- Prompting as a research skill; context management; when agentic tools help and when they compound errors
- **The central problem: LLMs produce plausible code that runs and returns wrong numbers.** Failure modes, silent merge errors, sample-selection changes, misapplied clustering, fabricated variable definitions, hallucinated citations
- Defensive workflow: assertion-based programming, unit tests for data, reconciliation against known quantities, adversarial self-review
- Reading code you did not write, and the reviewer's problem
- Data manipulation at scale (`data.table`, `polars`, `duckdb`) and visualization principles (`ggplot2`)

*In-class lab: an AI assistant is given a dirty dataset and a research question and produces a complete, confidently wrong analysis. Find every error.*

*Assignment 1 released: reproducible data pipeline (due Week 4).*

### Week 3 — Data Acquisition, Storage, and Provenance

- Relational databases and SQL; when your data outgrows memory
- Collecting data: APIs, scraping, and the practical and legal constraints
- How LLMs changed data collection: parsing unstructured sources, schema inference, and extraction from documents, images, and audio
- Data provenance and documentation; what "the data" means when part of it was generated by a model
- Sharing data and code; journal data-availability policies; privacy and licensing

### Week 4 — LLMs as Measurement Instruments I: Promise and Validation

- The measurement problem in marketing: constructs we care about (sentiment, quality, positioning, intent, similarity) live in unstructured data
- Embeddings and pretrained models; classification and annotation with LLMs
- Evidence on LLM annotation performance and its limits
- Designing a validation study: what to validate against, how much gold-standard data to collect, and how to sample it
- **Prompt sensitivity as a researcher degree of freedom**: the direct analogue of specification search

*Assignment 1 due. Assignment 2 released: measurement and validation exercise (due Week 6).*

*Papers:*

- **Required:** Gilardi, F., Alizadeh, M., & Kubli, M. (2023). ChatGPT outperforms crowd workers for text-annotation tasks. *PNAS*, 120(30), e2305016120.
- **Required:** Ziems, C., Held, W., Shaikh, O., Chen, J., Zhang, Z., & Yang, D. (2024). Can large language models transform computational social science? *Computational Linguistics*, 50(1), 237–291.
- **Required:** Li, P., Castelo, N., Katona, Z., & Sarvary, M. (2024). Frontiers: Determining the validity of large language models for automated perceptual analysis. *Marketing Science*, 43(2), 254–266.
- Baumann, J., Röttger, P., Urman, A., Wendsjö, A., Plaza-del-Arco, F. M., Gruber, J. B., & Hovy, D. (2025). Large language model hacking: Quantifying the hidden risks of using LLMs for text annotation. *arXiv:2509.08825*. [Working paper]
- Hartmann, J., & Netzer, O. (2023). Natural language processing in marketing. In *Artificial Intelligence in Marketing* (Review of Marketing Research, Vol. 20). Emerald. [Background for students without an NLP foundation]

### Week 5 — LLMs as Measurement Instruments II: Inference with Generated Variables

- The generated-regressor problem, generally: any variable that was *estimated* rather than *observed* (predicted probabilities, propensity scores, factor scores, a hand-coding RA, a random forest, an LLM) carries its estimation error into the regression (Pagan 1984; Murphy & Topel 1985)
- The core result: **a generated regressor with 85% accuracy does not give you a regression that is 85% right.** Plugging model-generated labels into a downstream regression produces biased coefficients and invalid confidence intervals, even at high accuracy
- What is genuinely new with LLMs: scale of adoption, the absence of labeled data by default, illegible error structure, prompt sensitivity, and non-reproducibility. And that an LLM classifier is not a *consistent* estimator, which is why modern corrections advertise working with arbitrarily biased surrogates
- Why this is not solved by "the errors are random": classification error is systematically correlated with the covariates you care about
- Corrections: design-based supervised learning, prediction-powered inference, and bias-corrected estimation. What each requires of your research design, in particular, that *you* control the gold-standard sampling probability
- Training-data leakage: when the LLM has already seen your outcome
- Simulated respondents and "silicon sampling": what it can and cannot deliver
- Practical guidance: how to write the measurement section of a paper that uses an LLM, and what referees will ask

*Papers:*

- **Required:** Egami, N., Hinck, M., Stewart, B. M., & Wei, H. (2023). Using imperfect surrogates for downstream inference: Design-based supervised learning for social science applications of large language models. *Advances in Neural Information Processing Systems*, 36.
- **Required:** Angelopoulos, A. N., Bates, S., Fannjiang, C., Jordan, M. I., & Zrnic, T. (2023). Prediction-powered inference. *Science*, 382(6671), 669–674.
- **Required:** Ludwig, J., Mullainathan, S., & Rambachan, A. (2025). Large language models: An applied econometric framework. NBER Working Paper No. 33344. [Working paper]
- **Required:** Wang, M., Zhang, D. J., & Zhang, H. (2026). Large language models for market research: A data-augmentation approach. *Marketing Science*, 45(4), 728–751.
- Battaglia, L., Christensen, T., Hansen, S., & Sacher, S. Inference for regression with variables generated by AI or machine learning. *arXiv:2402.15585*. [Working paper]
- Argyle, L. P., Busby, E. C., Fulda, N., Gubler, J. R., Rytting, C., & Wingate, D. (2023). Out of one, many: Using language models to simulate human samples. *Political Analysis*, 31(3), 337–351.
- Bisbee, J., Clinton, J. D., Dorff, C., Kenkel, B., & Larson, J. M. (2024). Synthetic replacements for human survey data? The perils of large language models. *Political Analysis*, 32(4), 401–416.
- Goli, A., & Singh, A. (2024). Frontiers: Can large language models capture human preferences? *Marketing Science*, 43(4), 709–722.
- Brand, J., Israeli, A., & Ngwe, D. Using LLMs for market research. HBS Working Paper 23-062. [Working paper]
- Toubia, O., Gui, G. Z., Peng, T., Merlau, D. J., Li, A., & Chen, H. (2025). Database report: Twin-2K-500. *Marketing Science*, 44(6), 1446–1455. [Assignable benchmark dataset]

### Week 6 — Credibility: Research Design, Specification Search, and Experiments

- The credibility problem restated: if a hundred specifications cost nothing to run, what does a reported specification mean?
- Specification search and p-hacking, revisited for a world of cheap analysis; multiple hypothesis testing; specification curves
- Pre-registration and pre-analysis plans as commitment devices; their limits
- Observational designs: what identification arguments survive contact with a referee
- Experiments in industry settings: A/B testing at scale, false discovery, incrementality and ghost ads
- Null results, publication bias, and what to do when the effect is not there
- Journal policies, replication, and dealing with reviewers

*Assignment 2 due.*

*Papers:*

- **Required:** Berman, R., & Van den Bulte, C. (2022). False discovery in A/B testing. *Management Science*, 68(9), 6762–6782.
- **Required:** Johnson, G. A., Lewis, R. A., & Nubbemeyer, E. I. (2017). Ghost ads: Improving the economics of measuring online ad effectiveness. *Journal of Marketing Research*, 54(6), 867–884.
- Simmons, J. P., Nelson, L. D., & Simonsohn, U. (2011). False-positive psychology. *Psychological Science*, 22(11), 1359–1366.
- Brodeur, A., Cook, N., & Heyes, A. (2020). Methods matter: p-hacking and publication bias in causal analysis in economics. *American Economic Review*, 110(11), 3634–3660.

### Week 7 — Project Presentations

Each student presents their semester project (see below). Instructor and peer feedback. We close with a discussion of how the first half connects to the structural methods covered in the second.

---

## Semester Project (First Half)

Beginning in Week 1, each student develops an original empirical project that uses an LLM as a measurement instrument, presented in Week 7. The project is deliberately scoped to be small enough to complete in seven weeks and large enough to become a dissertation chapter if it works.

**Requirements.** The project must:

1. Pose a marketing or economics research question that cannot be answered with off-the-shelf structured data
2. Describe the data and state an **identification argument**: what variation identifies the estimand, what must be true, and what would break it
3. Use an LLM to construct at least one variable from unstructured data (text, images, audio, or documents)
4. Include a **validation study** with human-labeled or otherwise verified gold-standard data, with the sampling scheme described explicitly
5. Report downstream estimates using an appropriate correction for the generated regressor, and compare them to the naive plug-in estimates
6. Be fully reproducible from a public or instructor-accessible repository, with a documented AI-use log

The project is a **measurement** project: use an LLM to measure something previously unmeasurable at scale, and use it to answer a substantive marketing question. Examples: positioning language in product descriptions; the emotional content of service interactions; visual attributes of listings; complaint taxonomies in reviews.

**Milestones.**

| Week | Date | Milestone |
|---|---|---|
| 1 | Aug 26 | Repository initialized |
| 2 | Sep 2 | One-paragraph question and data source identified |
| 3 | Sep 9 | Data acquired; pipeline reproducible; **identification argument drafted** |
| 4 | Sep 16 | Measurement approach specified; prompt and model documented; validation sample designed |
| 5 | Sep 23 | Validation complete; naive estimates reported |
| 6 | Sep 30 | Corrected estimates reported; identification argument revised; robustness plan |
| 7 | Oct 7 | 20-minute presentation + short written report |

**The identification memo.** The Week 3 deliverable is a memo of roughly 400–600 words, in the project repository, stating: the question; the data; the estimand; the variation that identifies it; what must be true for that variation to identify it; and what would break it. The last two are the memo. A memo that describes a dataset and a regression without naming an assumption that could fail has not done the assignment.

**The revision.** The Week 6 deliverable revisits the Week 3 memo in light of the validation study, and is due with the corrected estimates. The question it answers is whether measurement error changed what you are willing to claim. Mark changes from the Week 3 version so the revision is legible as a revision.

Often it will change a great deal. If validation shows classifier error is correlated with your treatment or your covariates, the estimand may need narrowing, the identifying assumption may need to be restated conditional on the error structure, and the naive and corrected estimates may support different conclusions. That case is the point of Weeks 4 and 5, and the revision should be a rewrite.

**Every project reports the naive and corrected estimates side by side, whether or not they differ.** This is the part that is not optional. If the two estimates agree, and validation shows measurement error that is modest and plausibly unrelated to the variation you exploit, then the Week 3 argument stands. Report the validation result, show both estimates, state that the identifying assumption is unchanged, and explain why. A paragraph or two is enough. Do not pad it. A short memo that documents a stable design is worth more than a long one that manufactures a revision the evidence does not support.

Null results are acceptable and will be graded on the quality of the design and the honesty of the reporting, not on whether the effect is significant. A well-executed project that finds nothing will receive a higher grade than a poorly identified project that finds something.

---

## Additional Readings — AI as an Object of Study (First Half)

These are not required weekly readings. They are background for anyone whose measurement project touches AI markets, and a map of where the open questions currently are.

**Algorithmic pricing and collusion**

- Calvano, E., Calzolari, G., Denicolò, V., & Pastorello, S. (2020). Artificial intelligence, algorithmic pricing, and collusion. *American Economic Review*, 110(10), 3267–3297.
- Assad, S., Clark, R., Ershov, D., & Xu, L. (2024). Algorithmic pricing and competition: Empirical evidence from the German retail gasoline market. *Journal of Political Economy*, 132(3), 723–771. [The strongest identification strategy in this literature]
- Brown, Z. Y., & MacKay, A. (2023). Competition in pricing algorithms. *AEJ: Microeconomics*, 15(2), 109–156.
- Fish, S., Gonczarowski, Y. A., & Shorrer, R. I. Algorithmic collusion by large language models. *arXiv:2404.00806*. [Working paper]
- Hansen, K., Misra, K., & Pai, M. (2021). Frontiers: Algorithmic collusion: Supra-competitive prices via independent algorithms. *Marketing Science*, 40(1), 1–12.

**Generative AI, content markets, and labor**

- Hui, X., Reshef, O., & Zhou, L. (2024). The short-term effects of generative artificial intelligence on employment: Evidence from an online labor market. *Organization Science*, 35(6), 1977–1989.
- del Rio-Chanona, M., Laurentsyeva, N., & Wachs, J. (2024). Large language models reduce public knowledge sharing on online Q&A platforms. *PNAS Nexus*, 3(9), pgae400.
- Burtch, G., Lee, D., & Chen, Z. (2024). The consequences of generative AI for online knowledge communities. *Scientific Reports*, 14, 10413.
- Demirci, O., Hannane, J., & Zhu, X. (2025). Who is AI replacing? The impact of generative AI on online freelancing platforms. *Management Science*, forthcoming.

**AI-mediated search and discovery**

- Donnelly, R., Kanodia, A., & Morozov, I. (2024). Welfare effects of personalized rankings. *Marketing Science*, 43(1), 92–113. [Pre-LLM anchor]
- Aggarwal, P., Murahari, V., Rajpurohit, T., Kalyan, A., Narasimhan, K., & Deshpande, A. (2024). GEO: Generative engine optimization. *KDD '24*, 5–16.

**Productivity experiments**

- Brynjolfsson, E., Li, D., & Raymond, L. (2025). Generative AI at work. *Quarterly Journal of Economics*, 140(2), 889–942.
- Noy, S., & Zhang, W. (2023). Experimental evidence on the productivity effects of generative artificial intelligence. *Science*, 381(6654), 187–192.
- Cui, K. Z., Demirer, M., Jaffe, S., Musolff, L., Peng, S., & Salz, T. (2025). The effects of generative AI on high-skilled work. *Management Science*, forthcoming.
- Becker, J., Rush, N., Barnes, E., & Rein, D. (2025). Measuring the impact of early-2025 AI on experienced open-source developer productivity. *arXiv:2507.09089*. [Working paper. Experienced developers were slowed by AI while believing they had been sped up, worth reading against the papers above]

**Consumer response to AI**

- Luo, X., Tong, S., Fang, Z., & Qu, Z. (2019). Frontiers: Machines vs. humans: The impact of artificial intelligence chatbot disclosure on customer purchases. *Marketing Science*, 38(6), 937–947.
- Longoni, C., Bonezzi, A., & Morewedge, C. K. (2019). Resistance to medical artificial intelligence. *Journal of Consumer Research*, 46(4), 629–650.

*A note on the retracted MIT paper.* Toner-Rodgers, "Artificial intelligence, scientific discovery, and product innovation" (*arXiv:2412.17866*) was withdrawn after MIT stated it had no confidence in the provenance or validity of the data. It was publicly endorsed by prominent economists before the fraud surfaced. We will discuss it in Week 6 as a case study in why reproducible pipelines and data provenance are not bureaucratic overhead.

---


## Lecture Outline (Second Half)

In the second part of this class, we will cover the structural estimation of choice models. We will begin by comparing structural analysis with descriptive and reduced-form analysis and discussing when structural analysis is most appropriate, as well as its benefits and limitations. We will then introduce the basics of general model identification and estimation. Next, we will cover canonical choice models, with a main focus on single-agent static models. Topics include models of individual discrete choice, selection, unobserved heterogeneity, BLP, and consumer search. Depending on the progress, some topics may be cut, and additional topics may be added. There is no required textbook for this section of the course, which is primarily based on journal readings, but you may find the following references helpful as background material:

Reiss, P. C., & Wolak, F. A. (2007). Structural econometric modeling: Rationales and examples from industrial organization. *Handbook of Econometrics*, 6, 4277–4415.

Train, K. E. (2009). *Discrete choice methods with simulation*. Cambridge University Press. (Free PDF at https://eml.berkeley.edu/books/choice2.html)

Hortaçsu, A., & Joo, J. (2023). Structural econometric modeling in industrial organization and quantitative marketing: theory and applications.

In each week, we will discuss several papers on a particular topic. In most cases, the instructor will introduce the topics prior to the assigned readings. Most required papers will be pre-assigned to a student, who will be responsible for presenting the paper to the class with a specific focus and providing a platform for general discussion. All non-presenting students are also expected to read the assigned papers and actively participate in the discussion. Some required papers will be covered through lectures and instructor-led discussions. You will be evaluated on the level of your contribution to the discussion of each paper, even if you are not presenting. *Please note that attendance at all class sessions and reading of all required papers are mandatory.*

---


## Overall Course Outline and Proposed Schedule

| Week | Date | Topic | Deliverable |
|---|---|---|---|
| 1 | Aug 26 | **Reproducible research infrastructure**: course overview; laptop setup; Git/GitHub; shell and remote computing; environment management; setting up an AI-assisted workflow | Project repo |
| 2 | Sep 2 | **AI-assisted analysis and the verification problem**: AI coding assistants for research tasks; failure modes; defensive workflow and testing; data manipulation and visualization | **Assignment 1 out**; project question |
| 3 | Sep 9 | **Data acquisition, storage, and provenance**: SQL and databases; APIs and scraping; LLM-based extraction from unstructured sources; documentation and sharing | Identification memo |
| 4 | Sep 16 | **LLMs as measurement instruments I**: annotation and classification; validation design; prompt sensitivity as researcher degrees of freedom | **Assignment 1 due**; **Assignment 2 out**; measurement plan |
| 5 | Sep 23 | **LLMs as measurement instruments II**: inference with generated variables; DSL, prediction-powered inference, bias correction; silicon sampling and its limits | Validation complete |
| 6 | Sep 30 | **Credibility**: specification search with cheap analysis; pre-registration; experiments, false discovery, incrementality; null results; journals and reviewers | **Assignment 2 due**; revised identification memo |
| 7 | Oct 7 | **Project presentations** | Presentation + report |

| | | **SECOND PART** | |
| 8 | Oct 14 | Basics of Structural and Non-Structural Analysis: course overview; descriptive vs. reduced-form vs. structural; when and why structural analysis: benefits and limitations | |
| 9 | Oct 21 | Basics of Model Identification and Estimation: model identification; estimation methods: (S)MLE, (S)GMM, NNE; empirical identification: sensitivity of estimates to moments | |
| 10 | Oct 28 | Discrete Choice Models (Individual-Level Data): binary choices: logit, probit; multiple choices: (L)MNL, MNP, (L)Nested logit; ordered responses | Assignment 1 |
| 11 | Nov 4 | Selection Models (Individual-Level Data): Tobit Type I–V; censored data, Heckman selection. Unobserved Heterogeneity: latent class; random coefficients | |
| 12 | Nov 11 | Veterans Day Holiday (No Class) | |
| 13 | Nov 18 | Demand for Differentiated Products (Aggregate Data): BLP fundamentals; BLP extension: long-tail market | Assignment 2 |
| 14 | Nov 25 | Thanksgiving Holiday (No Class) | |
| 15 | Dec 2 | Consumer Search Models: simultaneous and sequential search; identification with/without observed search | Assignment 3 |


*Note: In the second half, each student will have a turn presenting at least one of the papers assigned.*

---


## Seminar Readings (Second Half)

### Week 8: Basics of Structural and Non-Structural Analysis

**Required:** Reiss, P. C. (2011). Structural workshop paper—descriptive, structural, and experimental empirical methods in marketing research. *Marketing Science*, 30(6), 950–964.

**Required:** Rust, J. (2014). The limits of inference with theory: A review of Wolpin (2013). *Journal of Economic Literature*, 52(3), 820–850.

Chintagunta, P., Erdem, T., Rossi, P. E., & Wedel, M. (2006). Structural modeling in marketing: review and assessment. *Marketing Science*, 25(6), 604–616.

Keane, M. P. (2010). Structural vs. atheoretic approaches to econometrics. *Journal of Econometrics*, 156(1), 3–20.

### Week 9: Basics of Model Identification and Estimation

**Required:** Andrews, I., Gentzkow, M., & Shapiro, J. M. (2017). Measuring the sensitivity of parameter estimates to estimation moments. *The Quarterly Journal of Economics*, 132(4), 1553–1592.

**Required:** Wei, Y., & Jiang, Z. (2025). Estimating parameters of structural models using neural networks. *Marketing Science*, 44(1), 102–128.

Rothenberg, T. J. (1971). Identification in parametric models. *Econometrica*, 577–591.

Lewbel, A. (2019). The identification zoo: Meanings of identification in econometrics. *Journal of Economic Literature*, 57(4), 835–903.

Andrews, I., Gentzkow, M., & Shapiro, J. M. (2020). On the informativeness of descriptive statistics for structural estimates. *Econometrica*, 88(6), 2231–2258.

### Week 10: Discrete Choice Models (Individual-Level Data)

**Required:** Guadagni, P. M., & Little, J. D. (1983). A logit model of brand choice calibrated on scanner data. *Marketing Science*, 2(3), 203–238.

**Required:** Fader, P. S., & Hardie, B. G. (1996). Modeling consumer choice among SKUs. *Journal of Marketing Research*, 33(4), 442–452.

**Required:** Sifringer, B., Lurkin, V., & Alahi, A. (2020). Enhancing discrete choice models with representation learning. *Transportation Research Part B: Methodological*, 140, 236–261.

### Week 11: Selection Models and Unobserved Heterogeneity (Individual-Level Data)

**Required:** Gronau, R. (1973). The effect of children on the housewife's value of time. *Journal of Political Economy*, 81(2, Part 2), S168–S199.

**Required:** Kamakura, W. A., & Russell, G. J. (1989). A probabilistic choice model for market segmentation and elasticity structure. *Journal of Marketing Research*, 26(4), 379–390.

Heckman, J. J. (1979). Sample selection bias as a specification error. *Econometrica*, 153–161.

Amemiya, T. (1984). Tobit models: A survey. *Journal of Econometrics*, 24(1-2), 3–61.

### Week 13: Demand for Differentiated Products (Aggregate Data)

**Required:** Berry, S. T. (1994). Estimating discrete-choice models of product differentiation. *The RAND Journal of Economics*, 242–262.

**Required:** Berry, S., Levinsohn, J., & Pakes, A. (1995). Automobile prices in market equilibrium. *Econometrica*, 63(4), 841–890.

**Required:** Nevo, A. (2001). Measuring market power in the ready-to-eat cereal industry. *Econometrica*, 69(2), 307–342.

**Required:** Adam, H., He, P., & Zheng, F. (2024). Machine learning for demand estimation in long tail markets. *Management Science*, 70(8), 5040–5065.

Nevo, A. (2000). A practitioner's guide to estimation of random-coefficients logit models of demand. *Journal of Economics & Management Strategy*, 9(4), 513–548.

Gandhi, A., Lu, Z., & Shi, X. (2023). Estimating demand for differentiated products with zeroes in market share data. *Quantitative Economics*, 14(2), 381–418.

### Week 15: Consumer Search Models

**Required:** Mehta, N., Rajiv, S., & Srinivasan, K. (2003). Price uncertainty and consumer search: A structural model of consideration set formation. *Marketing Science*, 22(1), 58–84.

**Required:** Ursu, R. M. (2018). The power of rankings: Quantifying the effect of rankings on online consumer search and purchase decisions. *Marketing Science*, 37(4), 530–552.

**Required:** Honka, E., & Chintagunta, P. (2017). Simultaneous or sequential? Search strategies in the US auto insurance industry. *Marketing Science*, 36(1), 21–42.

Hong, H., & Shum, M. (2006). Using price distributions to estimate search costs. *The RAND Journal of Economics*, 37(2), 257–275.

Honka, E. (2014). Quantifying search and switching costs in the US auto insurance industry. *The RAND Journal of Economics*, 45(4), 847–884.

Santos, B. D. L., Hortaçsu, A., & Wildenbeest, M. R. (2012). Testing models of consumer search using data on web browsing and purchasing behavior. *American Economic Review*, 102(6), 2955–2980.

---


## Software Requirements and Online References

Each of these books/courses is freely available online:

- R for Marketing Research and Analytics
- Grant McDermott's EC 607 course, to whom I dedicate a special thank you for sharing the course material
- *Data Visualization: A Practical Introduction*, Kieran Healy
- *R for Data Science*, Garrett Grolemund and Hadley Wickham
- *Advanced R*, Hadley Wickham
- *R Markdown: The Definitive Guide*, Yihui Xie, JJ Allaire, and Garrett Grolemund
- Parallel computing in R
- Awesome Reproducible Research (a curated list of reproducible research case studies, projects, tutorials, and media)
- https://pytorch.org/tutorials/beginner/deep_learning_60min_blitz.htm
- An accessible introduction to PyTorch: https://cs230.stanford.edu/blog/pytorch/#models-in-pytorch

**VS Code** (the standard editor for the first half of this course)
https://code.visualstudio.com, install the R, Python, Remote-SSH, and Quarto extensions.

**R**
https://www.r-project.org/

**Python**, installed and managed with `uv`
https://docs.astral.sh/uv/ — `uv` installs Python for you and records the exact package versions your project used, so the environment can be rebuilt later. It replaces `pip`, `venv`, and `pyenv`.

**Git and GitHub**
https://git-scm.com/downloads · https://github.com/

**SQL client** (for browsing the course database directly)
Mac: https://sequel-ace.com/ · Windows: https://www.mysql.com/products/workbench/

**DuckDB**
https://duckdb.org/

**Course servers** (first half; USC network or VPN required)
Two Marshall research machines; addresses distributed in class. Connect with VS Code Remote-SSH.

**AI tools** (accounts required; the instructor will provide guidance on access in Week 1)
- Claude and Claude Code: https://claude.ai · https://claude.com/claude-code
- Anthropic API: https://docs.anthropic.com
- OpenAI API and Codex: https://platform.openai.com
- Cursor: https://cursor.com

**Statistical packages for generated-variable inference**
- `dsl` (design-based supervised learning, R): https://naokiegami.com/dsl/
- `ppi_py` (prediction-powered inference, Python): https://github.com/aangelopoulos/ppi_py

---

## Course Notes and Attendance

Please note that the professor reserves the right to make changes to this syllabus at any time throughout the semester. Changes to this syllabus, if any, will be announced and explained in class.

Attending class is an important part of learning. Your understanding of the course materials will be at a different level if you participate in the classes. It is the responsibility of the student to make up for missed lectures and discussion sections by meeting with a classmate to review what was discussed on the missed day, and by asking the professor questions during office hours regarding missed material.

## Grading Policies

Each half of the course will be evaluated by the respective instructors. The final grade will be an average of the two halves.

**Part I:**

| | Points | % of Grade |
|---|---|---|
| 2 Programming assignments | 20 | 20% |
| Semester project, presentation and report | 55 | 55% |
| Project milestones | 15 | 15% |
| Class participation | 10 | 10% |
| **TOTAL** | **100** | **100%** |


**Part II:**

| | Points | % of Grade |
|---|---|---|
| 3 Assignments | 60 | 60% |
| Presentation of pre-assigned papers | 30 | 30% |
| Class participation | 10 | 10% |
| **TOTAL** | **100** | **100%** |


**Submission (first half).** Everything is submitted through your own GitHub repository. Send me the URL; I clone it and run it. There is no separate document to upload.

A submission must run from a clean clone. Whatever you write in, R or Python, the repository needs a master script that runs the analysis in order, a pinned environment (`renv.lock` or `uv.lock`), no credentials in the history, and the AI-use appendix. Write-ups can be Markdown, Quarto, or RMarkdown, whichever you prefer, as long as they are in the repository and build from it.

For the second half, please follow Professor Chen's submission instructions.

Generally speaking, letter grade guidelines (which CAN change slightly, depending on overall class performance) are approximately as follows: "A" grades (A, A-) start at 90; "B" grades (B-, B, B+) start at 80; "C" grades (C-, C, C+) start at 70; "D" grades (D-, D, D+) start at 60; "F" grades (F) start at 59 or below. The grade ranges given in this paragraph are approximations only and are subject to change in situations where class averages on the various assignments are unusually high or low (because "relative performance" is an important aspect of the course grade). We will explain this further in class.

Your grade will not be based on a mandated target but on your performance.

---

# MARSHALL GUIDELINES

## Add/Drop Process

Most Marshall classes are open enrollment (R-clearance) through the Add deadline. If there is an open seat, students can add the class using Web Registration. If the class is full, students will need to continue checking the Schedule of Classes (classes.usc.edu) to see if a space becomes available. Students who do not attend the first two class sessions (for classes that meet twice per week) or the first class meeting (for classes that meet once per week) may be dropped from the course if they do not notify the instructor prior to their absence.

See the "Academic Records and Registrar" website for specific add/drop and related deadlines. (https://arr.usc.edu/). Please also refer to https://arr.usc.edu/calendar/ if you intend to drop a class, that link will give you deadlines to drop without a "W" on your transcript.

## Use of AI Generators

**The use of AI in the first half of this course is not merely permitted; it is required.** You cannot complete the semester project without it. The point of the course is to make you good at using these tools and, more importantly, good at catching them when they are wrong.

This changes what academic integrity means here. The concern is not that you used a model. The concern is that you reported a result you did not verify.

The following rules apply to all work in the first half:

**Disclosure.** Every submitted assignment must include an AI-use appendix stating which tools and models you used, for what, and how. For the semester project, this includes the exact prompts and model versions used to generate any variable that enters your analysis, along with the date accessed. Model behavior changes over time; an undocumented prompt is an unreproducible measurement instrument. Treat prompts the way you would treat the description of a survey instrument or a lab protocol.

**Verification.** You are responsible for every number, claim, and citation in your submitted work, regardless of what produced it. "The model generated it" is not a defense; it is an admission that you submitted unverified work. Assume that any figure or fact an AI tool gives you is wrong until you have confirmed it against a source you trust or derived it yourself. LLMs fabricate citations that look entirely plausible, check that every reference you cite exists and says what you claim it says.

**Understanding.** You must be able to explain any code you submit, line by line, and justify any specification choice it embodies. I may ask you to do exactly this in class. Code you cannot explain is code you should not have submitted.

**Honest reporting of failure.** If an AI tool led you into an error you later caught, say so in the appendix. This is the most valuable thing you can learn in this course, and reporting it will help, not hurt, your grade.

Failure to disclose AI use, or reporting results you did not verify, is a violation of academic integrity policies. Please ask the instructor if you are unsure about what constitutes unauthorized assistance on an assignment, or what information requires citation and/or attribution. If found responsible for an academic violation, students may be assigned university outcomes, such as suspension or expulsion from the university, and grade penalties, such as an "F" grade on the assignment and/or in the course.

For the second half of the course, please follow the guidance provided by Professor Chen.

## Academic Conduct

Plagiarism – presenting someone else's ideas as your own, either verbatim or recast in your own words – is a serious academic offense with serious consequences. Please familiarize yourself with the discussion of plagiarism in SCampus in Part B, Section 11, "Behavior Violating University Standards" policy.usc.edu/scampus-part-b. Other forms of academic dishonesty are equally unacceptable. See additional information in SCampus and university policies on Research and Scholarship Misconduct.

## Students and Disability Accommodations

USC welcomes students with disabilities into all of the University's educational programs. The Office of Student Accessibility Services (OSAS) is responsible for the determination of appropriate accommodations for students who encounter disability-related barriers. Once a student has completed the OSAS process (registration, initial appointment, and submitted documentation) and accommodations are determined to be reasonable and appropriate, a Letter of Accommodation (LOA) will be available to generate for each course. The LOA must be given to each course instructor by the student and followed up with a discussion. This should be done as early in the semester as possible as accommodations are not retroactive. More information can be found at osas.usc.edu. You may contact OSAS at (213) 740-0776 or via email at osasfrontdesk@usc.edu.

## Student Financial Aid and Satisfactory Academic Progress

To be eligible for certain kinds of financial aid, students are required to maintain Satisfactory Academic Progress (SAP) toward their degree objectives. Visit the Financial Aid Office webpage for undergraduate- and graduate-level SAP eligibility requirements and the appeals process.

## Support Systems

*Counseling and Mental Health* - (213) 740-9355 – 24/7 on call
Free and confidential mental health treatment for students, including short-term psychotherapy, group counseling, stress fitness workshops, and crisis intervention.

*988 Suicide and Crisis Lifeline* - 988 for both calls and text messages – 24/7 on call
The 988 Suicide and Crisis Lifeline (formerly known as the National Suicide Prevention Lifeline) provides free and confidential emotional support to people in suicidal crisis or emotional distress 24 hours a day, 7 days a week, across the United States. The Lifeline consists of a national network of over 200 local crisis centers, combining custom local care and resources with national standards and best practices. The new, shorter phone number makes it easier for people to remember and access mental health crisis services (though the previous 1 (800) 273-8255 number will continue to function indefinitely) and represents a continued commitment to those in crisis.

*CARE-SC: Confidential Advocacy, Resources, and Education Support Center* - (213) 740-9355(WELL) – 24/7/365 on call.
Confidential advocates, prevention educators, and professional counseling teams work to promote a universal culture of consent, and prevent and respond to gender- and power-based harm. Services available to all USC students at no cost.

*Office of Civil Rights Compliance* - (213) 740-5086
Information about how to get help or help someone affected by harassment, discrimination, retaliation on the basis of a protected characteristic, rights of protected classes, reporting options, and additional resources for students, faculty, staff, visitors, and applicants.

*Reporting Incidents of Bias or Harassment* - (213) 740-2500
Avenue to report incidents of bias, hate crimes, and microaggressions to the Office for Equity, Equal Opportunity, and Title for appropriate investigation, supportive measures, and response.

*The Office of Student Accessibility Services (OSAS)* - (213) 740-0776
OSAS ensures equal access for students with disabilities through providing academic accommodations and auxiliary aids in accordance with federal laws and university policy.

*USC Campus Support and Intervention* - (213) 740-0411
Assists students and families in resolving complex personal, financial, and academic issues adversely affecting their success as a student.

*USC Emergency Information*
Latest updates regarding safety, including ways in which instruction will be continued if an officially declared emergency makes travel to campus infeasible.

*USC Department of Public Safety*
For 24 hour emergency assistance or to report a crime: UPC: (213) 740-4321, HSC: (323)-442-1000.
For 24 hour non-emergency assistance or information: UPC: (213) 740-6000, HSC: 323-442-1200.

*Office of the Ombuds* - (213) 821-9556 (UPC) / (323-442-0382 (HSC)
A safe and confidential place to share your USC-related issues with a University Ombuds who will work with you to explore options or paths to manage your concern.

*Occupational Therapy Faculty Practice* - (323) 442-2850 or otfp@med.usc.edu
Confidential Lifestyle Redesign services for USC students to support health promoting habits and routines that enhance quality of life and academic performance.

## Emergency Preparedness/Course Continuity

In case of a declared emergency if travel to campus is not feasible, the USC Emergency Information web site (http://emergency.usc.edu/) will provide safety and other information, including electronic means by which instructors will conduct class using a combination of Blackboard, teleconferencing, and other technologies.

Please access our course site on Blackboard, where the course syllabus and many other important documents will be posted. Whether or not you use Blackboard regularly, these preparations will be crucial in an emergency. USC's Blackboard learning management system and support information is available at blackboard.usc.edu.

## Incomplete Grades

A mark of IN (incomplete) may be assigned when work is not completed because of a documented illness or other "emergency" that occurs after the 12th week of the semester (or the twelfth week equivalent for any course that is scheduled for less than 15 weeks).

An "emergency" is defined as a serious documented illness, or an unforeseen situation that is beyond the student's control, that prevents a student from completing the semester. Prior to the 12th week, the student still has the option of dropping the class. Arrangements for completing an IN must be initiated by the student and agreed to by the instructor prior to the final examination. If an Incomplete is assigned as the student's grade, the instructor is required to fill out an "Assignment of an In-complete (IN) and Requirements for Completion" form which specifies to the student and to the department the work remaining to be done, the procedures for its completion, the grade in the course to date, and the weight to be assigned to work remaining to be done when the final grade is computed. Both the instructor and student must sign the form with a copy of the form filed in the department. Class work to complete the course must be completed within one calendar year from the date the IN was assigned. The IN mark will be converted to an F grade should the course not be completed within the time allowed.
