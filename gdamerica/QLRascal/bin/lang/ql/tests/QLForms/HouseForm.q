form HouseForm{ SoldHouse: "Did you sell a house in 2010?" boolean
				Job: "Do you have a job?" boolean	
				if(SoldHouse){
				Debt: "Private debts for the sold house:" int
				Price: "Price the house was sold for:" int
				valueResidue: "Value residue:" int(Price - Debt)
				}		
				if(Job){
				BrutoIncome: "Bruto Monthly income:" int
				NettoIncome: "Netto Monthly income" int
				}
				
}



