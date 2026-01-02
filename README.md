# autopk_synthetic_example
Code example for article https://www.researchsquare.com/article/rs-4534358/v1?redirect=/article/rs-4534358

To run model search example:
- Use enviroment with NONMEM & PyDarwin.
- Edit options file to update data directory, working dir and NMFE path (can run `which NMFE` if path not known).
- Run: `python -m darwin.run_search template.txt tokens.json options.json`


Parameter space files for running extravascular model search with PyDarwin.
- Files required PyDarwin: template.txt, tokens.json, options.json, penalty.py

Penalty function can tested outside of PyDarwin using `python penalty.py`.

Some example model evaluations are included in the compressed directory /temp.
Can run the penalty functions on the 1st 20 model evaluations performed on a model search with synthetic data.
