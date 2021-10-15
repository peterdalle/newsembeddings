# newsembeddings

Svensk word2vec tränad på 923 766 nyhetsartiklar från 19 svenska nyhetssajter
från sommaren 2019 till april 2021.

Detta är mest tänkt att användas för min egen skull för att kunna bygga
ordlistor med relaterade nyckelord, och därför är träningen inte så omfattande
eller systematisk. Men jag tänkte att andra kanske skulle kunna ha nytta av den också.

## Använd

1. Ladda ned alla ZIP-filerna, zippa ut filen `wordvectors.rds`.
2. Öppna sedan filen `2-use-wordvectors.r`.
3. Kör koden i filen, exempelvis:

```r
wordvectors %>%
  related_words(word="regeringen", n=20)
```

```
           word      prob
1    regeringen 1.0000000
2   regeringens 0.9023843
3     förslaget 0.8406141
4       förslag 0.8269413
5     riksdagen 0.8212969
6        kräver 0.8002114
7      föreslår 0.7981808
8      regering 0.7918022
9      åtgärder 0.7871345
10         krav 0.7834189
11       frågan 0.7724232
12       löfven 0.7678431
13  politikerna 0.7623220
14  moderaterna 0.7617134
15 kommissionen 0.7588270
16   föreslagit 0.7566027
17       kravet 0.7545496
18       införa 0.7479441
19       därför 0.7461548
20         stöd 0.7428254
```

## Träning

Hyperparametrar etc. finns beskrivna i filen `1-train.r`.

Det tog ungefär tre timmar att träna på en 12-kärnig CPU.
