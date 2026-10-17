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

pbc set {280 280 280}

set N 100    ;# number of units   
set P 8   ;# total monomers   
set C 2    ;# number of grafts  

set particles_per_unit [expr {$P + 1}]
set monomers_per_chain [expr {$P / $C}]

for {set u 0} {$u < $N} {incr u} {
    set nano_index [expr {$u * $particles_per_unit}]
    
    for {set c 0} {$c < $C} {incr c} {
        set chain_start_offset [expr {1 + ($c * $monomers_per_chain)}]
        set first_monomer_index [expr {$nano_index + $chain_start_offset}]
        
        topo addbond $nano_index $first_monomer_index
        
        for {set m 0} {$m < [expr {$monomers_per_chain - 1}]} {incr m} {
            set current_monomer [expr {$first_monomer_index + $m}]
            set next_monomer [expr {$current_monomer + 1}]
            
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