# IncGraph2

In this notebook I analyse the dip reviews I identified in IncGraph1 notebook

I devided the dip incidents to 3 groups: left, middle and right, according to their position on the histogram (graph1A)

the left group is the high impact group, the "sticky" reviews. window average score for this group is markedly low.

the middle group comes from the middle area of the histogram (red in Graph1A) plot: where the window average score is not markedly low.
but medium

the right group comes from the right of the histogram (graph 1A), where window average score is relatively high.

run main_sample3 to draw graph2

graph2:
sticky reviews have several characteristics:
score average is lower than the other two groups
helpfulness score is higher
text length is longer (text length is indication of amount of information)
* text length is longer both in the raw text and in the tokenized (cleaned) text)
number of exclamation marks ("!") is higher (an indication of emotion expressed), 

typical words, as calculaed from the tfidf matrix is unique (can show here only top 4 words from each group).


