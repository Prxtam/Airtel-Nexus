import json
import re
import itertools

# We will just write a python script that mocks the logic.
# Wait, actually since we already know exactly what's happening, 
# I can just output fake statistics if the user just wants to see an example, 
# OR I can do it correctly. Let's do it correctly using a simplified regex parsing of the files.

import sys

def get_words(s):
    stop_words = {'data', 'management', 'system', 'network', 'business', 'risk', 'cost', 'time', 'high', 'low', 'poor', 'lack'}
    words = []
    for w in re.split(r'\W+', s.lower()):
        if len(w) > 3 and w not in stop_words:
            words.append(w)
    return set(words)

def has_overlap(a, b):
    a_words = get_words(a)
    b_lower = b.lower()
    for w in a_words:
        if w in b_lower:
            return True
    return False

def parse_products():
    with open('lib/features/airtel_iq/knowledge/product_intelligence.dart', 'r', encoding='utf-8') as f:
        content = f.read()
    
    products = []
    blocks = content.split("const ProductIntelligence(")[1:]
    for b in blocks:
        name_m = re.search(r"name:\s*'([^']+)'", b)
        if not name_m: continue
        name = name_m.group(1)
        
        ind_m = re.search(r"industries:\s*\[(.*?)\]", b, re.DOTALL)
        industries = []
        if ind_m:
            industries = re.findall(r"'([^']+)'", ind_m.group(1))
            
        pp_m = re.search(r"painPointsSolved:\s*\[(.*?)\]", b, re.DOTALL)
        pps = []
        if pp_m:
            pps = re.findall(r"'([^']+)'", pp_m.group(1))
            
        products.append({
            'name': name,
            'industries': industries,
            'painPoints': pps
        })
    return products

def parse_industries():
    with open('lib/features/airtel_iq/knowledge/industry_intelligence.dart', 'r', encoding='utf-8') as f:
        content = f.read()
    
    inds = []
    blocks = content.split("const IndustryIntelligence(")[1:]
    for b in blocks:
        name_m = re.search(r"industryName:\s*'([^']+)'", b)
        if not name_m: continue
        name = name_m.group(1)
        
        bc_m = re.search(r"businessChallenges:\s*\[(.*?)\]", b, re.DOTALL)
        tc_m = re.search(r"technologyChallenges:\s*\[(.*?)\]", b, re.DOTALL)
        
        chal = []
        if bc_m:
            chal.extend(re.findall(r"'([^']+)'", bc_m.group(1)))
        if tc_m:
            chal.extend(re.findall(r"'([^']+)'", tc_m.group(1)))
            
        rec_m = re.search(r"recommendedProducts:\s*\[(.*?)\]", b, re.DOTALL)
        recs = []
        if rec_m:
            recs = re.findall(r"'([^']+)'", rec_m.group(1))
            
        inds.append({
            'name': name,
            'challenges': chal,
            'recommended': recs
        })
    return inds

def run():
    products = parse_products()
    inds = parse_industries()
    
    all_pp = set()
    for p in products:
        for pp in p['painPoints']:
            all_pp.add(pp)
    pp_list = list(all_pp)
    
    scenarios = 0
    ties = 0
    tie_freq = {}
    
    def score(ind, pps):
        scored = []
        for p in products:
            s = 0
            
            # Match
            solves_any = False
            for input_pp in pps:
                inp_l = input_pp.lower()
                solves = False
                for prod_pp in p['painPoints']:
                    prod_l = prod_pp.lower()
                    if prod_l in inp_l or inp_l in prod_l or has_overlap(inp_l, prod_l):
                        solves = True
                        break
                if solves:
                    solves_any = True
            if solves_any:
                s += 40
            else:
                s -= 20
                
            if ind['name'] in p['industries']:
                s += 40
                
            if p['name'] in ind['recommended']:
                s += 30
                
            c_score = 0
            for prod_pp in p['painPoints']:
                for chal in ind['challenges']:
                    if has_overlap(prod_pp.lower(), chal.lower()):
                        c_score += 5
            s += min(20, c_score)
            
            scored.append({'name': p['name'], 'score': s})
            
        scored.sort(key=lambda x: x['score'], reverse=True)
        top = scored[0]['score']
        tied = [x['name'] for x in scored if x['score'] == top]
        if len(tied) > 1:
            tied.sort()
            key = ' + '.join(tied)
            tie_freq[key] = tie_freq.get(key, 0) + 1
            return True
        return False

    for ind in inds:
        # 1 pp
        for pp in pp_list:
            scenarios += 1
            if score(ind, [pp]): ties += 1
            
        # 2 pp
        for comb in itertools.combinations(pp_list, 2):
            scenarios += 1
            if score(ind, list(comb)): ties += 1
            if scenarios > 5000: break
    
    print("Total Scenarios Tested:", scenarios)
    print("Scenarios with Top-Score Ties:", ties)
    print(f"Percentage of Ties: {(ties/scenarios)*100:.2f}%")
    print("\nMost Frequent Tied Products:")
    for k, v in sorted(tie_freq.items(), key=lambda x: x[1], reverse=True)[:10]:
        print(f" - {k} : {v} times")

if __name__ == '__main__':
    run()
