# Attacker policy

## Psudo-code:
movement of attacker i:
1. if there is a defender in a certain radius (e.g. 2 meters) :  
    - 1.1 if there is a defender at the right ([-pi/2,0)):  
        - 1.1.1 Rotate towards left side.  
    - 1.2 else if there is a defender at the left ([0,pi/2]):  
        - 1.1.2 Rotate towards right side.  
2. else:  
    - 2.1. Move towards the closest vertex of the protected zone  
