SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[pTotalizaNF] 
(
@NFInput		Int, 
@Site			Char(1),
@TotalNF		Decimal(10,2) = Null Output, 
@ISS			Decimal(10,2)=Null Output 
)
AS
	Declare @AliqISS  	Decimal(10,2)  
	Begin Transaction 
	Set @TotalNF = 
	(IsNull((Select Cast(Sum(Vlr_Pgto_NF_HIM) as decimal(10,2)) From Cta_Cte_Hou_Imp_Mar Where Num_NF_HIM = @NFInput and DC_HIM = 'C' and Ref_Acesso_NF_HIM = @Site),0) - 
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_HIM) as decimal(10,2)) From Cta_Cte_Hou_Imp_Mar Where Num_NF_HIM = @NFInput and DC_HIM = 'D' and Ref_Acesso_NF_HIM = @Site),0) +

		 IsNull((Select Cast(Sum(Vlr_Pgto_NF_HIO) as decimal(10,2)) From Cta_Cte_Hou_Imp_Out Where Num_NF_HIO = @NFInput and DC_HIO = 'C' and Ref_Acesso_NF_HIO = @Site),0) - 
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_HIO) as decimal(10,2)) From Cta_Cte_Hou_Imp_Out Where Num_NF_HIO = @NFInput and DC_HIO = 'D' and Ref_Acesso_NF_HIO = @Site),0) +

	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_HIA) as decimal(10,2)) From Cta_Cte_Hou_Imp_Aer Where Num_NF_HIA = @NFInput and DC_HIA = 'C' and Ref_Acesso_NF_HIA = @Site),0) - 
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_HIA) as decimal(10,2)) From Cta_Cte_Hou_Imp_Aer Where Num_NF_HIA = @NFInput and DC_HIA = 'D' and Ref_Acesso_NF_HIA = @Site),0) + 

	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_HEM) as decimal(10,2)) From Cta_Cte_Hou_Exp_Mar Where Num_NF_HEM = @NFInput and DC_HEM = 'C' and Ref_Acesso_NF_HEM = @Site),0) -
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_HEM) as decimal(10,2)) From Cta_Cte_Hou_Exp_Mar Where Num_NF_HEM = @NFInput and DC_HEM = 'D' and Ref_Acesso_NF_HEM = @Site),0) +

	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_HEO) as decimal(10,2)) From Cta_Cte_Hou_Exp_Out Where Num_NF_HEO = @NFInput and DC_HEO = 'C' and Ref_Acesso_NF_HEO = @Site),0) -
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_HEO) as decimal(10,2)) From Cta_Cte_Hou_Exp_Out Where Num_NF_HEO = @NFInput and DC_HEO = 'D' and Ref_Acesso_NF_HEO = @Site),0) +

	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_HEA) as decimal(10,2)) From Cta_Cte_Hou_Exp_Aer Where Num_NF_HEA = @NFInput and DC_HEA = 'C' and Ref_Acesso_NF_HEA = @Site),0) - 
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_HEA) as decimal(10,2)) From Cta_Cte_Hou_Exp_Aer Where Num_NF_HEA = @NFInput and DC_HEA = 'D' and Ref_Acesso_NF_HEA = @Site),0) + 

	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_MIM) as decimal(10,2)) From Cta_Cte_Mas_Imp_Mar Where Num_NF_MIM = @NFInput and DC_MIM = 'C' and Ref_Acesso_NF_MIM = @Site),0) - 
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_MIM) as decimal(10,2)) From Cta_Cte_Mas_Imp_Mar Where Num_NF_MIM = @NFInput and DC_MIM = 'D' and Ref_Acesso_NF_MIM = @Site),0) + 
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_MIA) as decimal(10,2)) From Cta_Cte_Mas_Imp_Aer Where Num_NF_MIA = @NFInput and DC_MIA = 'C' and Ref_Acesso_NF_MIA = @Site),0) - 
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_MIA) as decimal(10,2)) From Cta_Cte_Mas_Imp_Aer Where Num_NF_MIA = @NFInput and DC_MIA = 'D' and Ref_Acesso_NF_MIA = @Site),0) + 
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_MEM) as decimal(10,2)) From Cta_Cte_Mas_Exp_Mar Where Num_NF_MEM = @NFInput and DC_MEM = 'C' and Ref_Acesso_NF_MEM = @Site),0) -
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_MEM) as decimal(10,2)) From Cta_Cte_Mas_Exp_Mar Where Num_NF_MEM = @NFInput and DC_MEM = 'D' and Ref_Acesso_NF_MEM = @Site),0) +
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_MEA) as decimal(10,2)) From Cta_Cte_Mas_Exp_Aer Where Num_NF_MEA = @NFInput and DC_MEA = 'C' and Ref_Acesso_NF_MEA = @Site),0) - 
	     IsNull((Select Cast(Sum(Vlr_Pgto_NF_MEA) as decimal(10,2)) From Cta_Cte_Mas_Exp_Aer Where Num_NF_MEA = @NFInput and DC_MEA = 'D' and Ref_Acesso_NF_MEA = @Site),0) )
        Set @AliqISS = (Select Aliq_ISS From Base_Nota_Fiscal Where Nota_Fiscal = @NFInput and Ref_Acesso = @Site)		
	    Set @ISS = (@TotalNF*  (@AliqISS /100)) 
	    Update Base_Nota_Fiscal Set Valor_Total = @TotalNF, Valor_ISS = @ISS Where Nota_Fiscal = @NFInput and Ref_Acesso = @Site 	



	Commit Transaction

GO
