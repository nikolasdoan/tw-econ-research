# Taiwan economic research: rules for Claude

This project is separate from the bizmap map (tecxmate/bizmap). Never read from, write to or reference that repo's
code, its database or its infrastructure here. The research manager reports to the bizmap cloud manager, who takes
gate decisions to Niko.

## The protocol (D280)

Seven stages, each with a gate: 1 literature review · 2 pre-registration (Niko and one reviewer sign) · 3 data build ·
4 analysis exactly as pre-registered · 5 red team that never saw the analysis code · 6 a human economist's read ·
7 working paper. A study that meets a kill rule is written up as a short note, not dropped.

- **Pre-registration first.** Nothing in `data/` that holds an outcome is opened, plotted or summarised before the
  pre-registration is committed. Its commit date is the proof. Any analysis not in it is labelled "exploratory".
- **No forking.** One primary outcome. Robustness tests are listed in advance; results of every listed test are reported.
- **Sources, never methods.** Every source is named with its licence (政府資料開放授權條款 v1 or equivalent only).
  Data built from the bizmap registry is described only as "registry records linked by 統一編號". Never describe how
  records were geocoded, placed or joined.
- **People.** Sole proprietorships and partnerships (獨資/合夥) are natural persons: counts only, never a name. No
  統一編號, business name, address or owner appears in `data/`, `paper/` or `reviews/`. Cells under 3 stay `<3`.
- **Citations.** Open every source you cite; a search snippet is not a source.
- **Not used:** twse.com.tw and tpex.org.tw web pages; TEJ.

## Working

- Budget: US$1,000 for the pilot across every session, reported at each gate in `notes/spend.md`; stop at US$800 and ask.
- Plain English, short sentences. Figures with labelled axes and units.
- Commits end with the Claude Code attribution lines; no model names in commits or files.
