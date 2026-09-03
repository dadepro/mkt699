# Regenerate the Word syllabus from the markdown. Never hand-edit the .docx.
# reference-black.docx is pandoc's default reference with the title, headings,
# hyperlinks, and theme accents set to black; a plain `pandoc x.md -o x.docx`
# brings back blue headings.
mkt-699-Fall2026-revised.docx: mkt-699-Fall2026-revised.md reference-black.docx
	pandoc $< --reference-doc=reference-black.docx --highlight-style=monochrome -o $@
