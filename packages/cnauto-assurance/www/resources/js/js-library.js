// /packages/cnauto-assurances/www/resources/js/js-library.js

function FillFieldsOnChange(i) {
    var assuranceId = document.getElementById('assurance_id').value;
    
    // PartsTotalCost
    var partsTotalCostObj = document.getElementById('parts_total_cost');
    var partsTotalCost = parseFloat(partsTotalCostObj.value, 10);
    
    if (isNaN(partsTotalCost)) {
	partsTotalCost = 0;
    } else {
        partsTotalCost = 0;
    }


    // assuranceTotalCost 
    var assuranceTotalCostObj = document.getElementById('assurance_total_cost');
    var assuranceTotalCost = parseFloat(assuranceTotalCostObj.value, 10);
    
    if (isNaN(assuranceTotalCost)) {
	assuranceTotalCost = 0;
    } else {
        assuranceTotalCost = 0;
    }

    // ThirdTotalCost
    var thirdTotalCostObj = document.getElementById('third_total_cost');
    var thirdTotalCost = parseFloat(thirdTotalCostObj.value, 10);
    
    if (isNaN(thirdTotalCost)) {
	thirdTotalCost = 0;
    } else {
       thirdTotalCost = 0;
    }



    for (var count = 0; count <= i; count++) { 
	
	// PartCost
	var partCostObj = document.getElementById('part_cost.' + count);
	var partCost = parseFloat(partCostObj.value, 10);
	
	if (isNaN(partCost)) {
	    alert ("You should input only numeric values, instead of " + partCostObj.value);
	    window.document.assurance_ae_2.partCostObj.focus();
	}
	
	// Quantity
	var partQuantityObj = document.getElementById('part_quantity.' + count);
	var partQuantity = parseFloat(partQuantityObj.value, 10);
	
	if (isNaN(partQuantity)) {
	    alert ("You should input only numeric values, instead of " + partQuantityObj.value);
	    window.document.assurance_ae_2.partQuantityObj.focus();
	}


	// AssuranceCost
	//Set assurance_cost = part_cost - (part_cost * 20/100)
	var assuranceCostObj = document.getElementById('assurance_cost.' + count);
	assuranceCostObj.value = partCost + (partCost * 20 / 100);



	// Third Services
	var thirdCostObj = document.getElementById('third_cost.' + count);
	var thirdCost = parseFloat(thirdCostObj.value, 10);
	
	if (isNaN(thirdCost)) {
	    alert ("You should input only numeric values, instead of " + thirdCostObj.value);
	    window.document.assurance_ae_2.thirdCostObj.focus();
	}

	thirdTotalCost = thirdTotalCost + thirdCost;



	// Totals

	partsTotalCost = (partCost * partQuantity) + partsTotalCost;

	

	
	

    }
    
    partsTotalCostObj.value = partsTotalCost;
    assuranceTotalCostObj.value = partsTotalCost + (partsTotalCost * 20 /100);
    thirdTotalCostObj.value = thirdTotalCost;


    var totalCostObj = document.getElementById('total_cost');
    totalCostObj.value = thirdTotalCost + partsTotalCost + (partsTotalCost * 20 /100);

} 
