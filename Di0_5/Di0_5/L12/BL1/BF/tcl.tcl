topo clearbonds
set sel [atomselect top "name O"] ;# nanoparticle
$sel set mass 421.875
$sel set charge 0

set sel [atomselect top "name C"] ;# polymer
$sel set mass 1
$sel set charge 1

set sel [atomselect top "name H"] ;# polymer
$sel set mass 1
$sel set charge -1

set sel [atomselect top "name N"] ;# polymer
$sel set mass 1
$sel set charge 0

set N 100    ;# number of units   
set P 24     ;# total monomers   
set C 2      ;# number of grafts  

set particles_per_unit [expr {$P + 1}]
set monomers_per_chain [expr {$P / $C}]

# NEW: Set everything to molecule 1 by default (these will be the flexible tails)
set all [atomselect top all]
$all set resid 1
$all delete

for {set u 0} {$u < $N} {incr u} {
    set nano_index [expr {$u * $particles_per_unit}]
    
    # Calculate the rigid molecule ID for this unit (starts at 2, goes to 101)
    set rigid_mol_id [expr {$u + 2}]
    
    # 1. Assign the rigid molecule ID to the nanoparticle core
    set core_sel [atomselect top "index $nano_index"]
    $core_sel set resid $rigid_mol_id
    $core_sel delete
    
    for {set c 0} {$c < $C} {incr c} {
        set chain_start_offset [expr {1 + ($c * $monomers_per_chain)}]
        set first_monomer_index [expr {$nano_index + $chain_start_offset}]
        
        # 2. Assign the EXACT SAME molecule ID to the first grafted monomer
        set graft_sel [atomselect top "index $first_monomer_index"]
        $graft_sel set resid $rigid_mol_id
        $graft_sel delete
        
        # Draw the bond between the core and the first monomer
        topo addbond $nano_index $first_monomer_index
        
        for {set m 0} {$m < [expr {$monomers_per_chain - 1}]} {incr m} {
            set current_monomer [expr {$first_monomer_index + $m}]
            set next_monomer [expr {$current_monomer + 1}]
            
            # Draw bonds for the flexible tail
            topo addbond $current_monomer $next_monomer
        }
    }
}

topo guessangles
topo retypebonds
topo retypeangles

topo numbonds
topo numangles

topo writelammpsdata initialsys.config
animate write psf psf.psf