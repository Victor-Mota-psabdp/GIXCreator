SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE pItensNFModal_Sel
(
@NF			VarChar(6),
@Site			Char(1), 
@Importacao 		Bit=0 OUTPUT,
@Exportacao 		Bit=0 OUTPUT,
@Maritimo		Bit=0 OUTPUT, 
@Aereo			Bit=0 OUTPUT,
@Recife		Bit=0 OUTPUT
)
AS
	If Exists(
		Select 
			Cte.Num_Proc_HIM as Processo
		From 
			Cta_Cte_Hou_Imp_Mar as Cte
		Where
			Cte.Num_NF_HIM = @NF  and
			Ref_Acesso_NF_HIM = @Site 
		Union 
		Select 
			Cte.Num_Proc_MIM as Processo
		From 
			Cta_Cte_Mas_Imp_Mar as Cte 
		Where
			Cte.Num_NF_MIM = @NF and
			Ref_Acesso_NF_MIM = @Site ) 
		Begin 
			Set @Importacao = 1 
			Set @Maritimo = 1 
			If  Exists(
				Select 
					Cte.Num_Proc_HIM as Processo
				From 
					Cta_Cte_Hou_Imp_Mar as Cte
				Where
					Cte.Num_NF_HIM = @NF  and
					Ref_Acesso_NF_HIM = @Site  and 
					Left (Num_Proc_HIM,5) = 'IMREC'
				Union 
				Select 
					Cte.Num_Proc_MIM as Processo
				From 
					Cta_Cte_Mas_Imp_Mar as Cte 
				Where
					Cte.Num_NF_MIM = @NF and
					Ref_Acesso_NF_MIM = @Site  and 
					Left (Num_Proc_MIM,5) = 'IMREC') 
				Set @Recife =1
			Else
				Set @Recife =0

		End 
		

	If Exists(	Select 
			Cte.Num_Proc_HEM as Processo
		From 
			Cta_Cte_Hou_Exp_Mar as Cte 
		Where
			Cte.Num_NF_HEM = @NF and
			Ref_Acesso_NF_HEM = @Site 
	
		Union
	
		Select 
			Cte.Num_Proc_MEM as Processo
		From 
			Cta_Cte_Mas_Exp_Mar as Cte 
		Where
			Cte.Num_NF_MEM = @NF and
			Ref_Acesso_NF_MEM = @Site ) 
		Begin 
			Set @Exportacao = 1 
			Set @Maritimo = 1 
			If  Exists(Select 
					Cte.Num_Proc_HEM as Processo
				From 
					Cta_Cte_Hou_Exp_Mar as Cte 
				Where
					Cte.Num_NF_HEM = @NF and
					Ref_Acesso_NF_HEM = @Site and
					Left(Num_Proc_HEM ,5) = 'EMREC'
			
				Union
			
				Select 
					Cte.Num_Proc_MEM as Processo
				From 
					Cta_Cte_Mas_Exp_Mar as Cte 
				Where
					Cte.Num_NF_MEM = @NF and
					Ref_Acesso_NF_MEM = @Site and
					Left(Num_Proc_MEM ,5) = 'EMREC') 
					Set @Recife = 1
			Else
				Set @Recife =0
		End 

	If Exists(	Select 
			Cte.Num_Proc_HIA as Processo
		From 
			Cta_Cte_Hou_Imp_Aer as Cte 
		Where
			Cte.Num_NF_HIA = @NF and
			Ref_Acesso_NF_HIA = @Site 
		
		Union

		Select 
			Cte.Num_Proc_MIA as Processo
		From 
			Cta_Cte_Mas_Imp_Aer as Cte 
		Where
			Cte.Num_NF_MIA = @NF  and
			Ref_Acesso_NF_MIA = @Site ) 
		Begin 
			Set @Importacao = 1 
			Set @Aereo = 1 
			If Exists(	Select 
					Cte.Num_Proc_HIA as Processo
				From 
					Cta_Cte_Hou_Imp_Aer as Cte 
				Where
					Cte.Num_NF_HIA = @NF and
					Ref_Acesso_NF_HIA = @Site and 
					Left(Num_Proc_HIA, 5) = 'IAREC'
				
				Union
		
				Select 
					Cte.Num_Proc_MIA as Processo
				From 
					Cta_Cte_Mas_Imp_Aer as Cte 
				Where
					Cte.Num_NF_MIA = @NF  and
					Ref_Acesso_NF_MIA = @Site and 
					Left(Num_Proc_MIA, 5) = 'IAREC') 

					Set @Recife = 1 
			Else
				Set @Recife =0

		End 

	If Exists(	Select 
			Cte.Num_Proc_HEA as Processo
		From 
			Cta_Cte_Hou_Exp_Aer as Cte 
		Where
			Cte.Num_NF_HEA = @NF and
			Ref_Acesso_NF_HEA = @Site 
			
		Union
		Select 
			Cte.Num_Proc_MEA as Processo
		From 
			Cta_Cte_Mas_Exp_Aer as Cte 
		Where
			Cte.Num_NF_MEA = @NF and
			Ref_Acesso_NF_MEA = @Site) 
		Begin 
			Set @Exportacao = 1 
			Set @Aereo = 1 
			If   Exists(Select 
					Cte.Num_Proc_HEA as Processo
				From 
					Cta_Cte_Hou_Exp_Aer as Cte 
				Where
					Cte.Num_NF_HEA = @NF and
					Ref_Acesso_NF_HEA = @Site and 
					Left(Num_Proc_HEA, 5) = 'EAREC'
					
				Union
				Select 
					Cte.Num_Proc_MEA as Processo
				From 
					Cta_Cte_Mas_Exp_Aer as Cte 
				Where
					Cte.Num_NF_MEA = @NF and
					Ref_Acesso_NF_MEA = @Site and 
					Left(Num_Proc_MEA, 5) = 'EAREC') 
			
					Set @Recife = 1 
			Else
				Set @Recife =0
		End

GO
