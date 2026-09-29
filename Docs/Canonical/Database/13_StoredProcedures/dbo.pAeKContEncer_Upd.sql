SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[pAeKContEncer_Upd]
AS
	Declare @Periodo VarChar(7) 
	Declare @Mes 	Int 
	Declare @ano	Int 
	Set @Periodo = (select PkcMes from param_aekcontabil) 
	Set @Mes = Cast(left(@Periodo, 2) as int) + 1 
	Set @Ano = Cast(right(@Periodo, 4) as int) 
	If @Mes = 13 
		Begin 
			Set @Ano = @Ano + 1 
			Set @Mes = 1 
		End 

	
	Set @Periodo = '0' + Cast(@Mes as varchar(2)) 
	Set @Periodo = right(@Periodo, 2)  + '/' + Cast(@Ano  as VarChar(4))

	Update param_aekcontabil set pkcmes = @periodo

	Update Cta_Cte_Hou_Imp_Mar Set Vlr_Contab_Ant   = Val_Con_Comp
	Update Cta_Cte_Hou_Imp_Aer Set Vlr_Contab_Ant   = Val_Con_Comp
	Update Cta_Cte_Hou_Exp_Mar Set Vlr_Contab_Ant   = Val_Con_Comp 
	Update Cta_Cte_Hou_Exp_Aer Set Vlr_Contab_Ant   = Val_Con_Comp
	Update Cta_Cte_Hou_Imp_Out Set Vlr_Contab_Ant   = Val_Con_Comp 
	Update Cta_Cte_Hou_Exp_Out Set Vlr_Contab_Ant   = Val_Con_Comp

	Update Cta_Cte_Mas_Imp_Mar Set Vlr_Contab_Ant   = Val_Con_Comp
	Update Cta_Cte_Mas_Imp_Aer Set Vlr_Contab_Ant   = Val_Con_Comp
	Update Cta_Cte_Mas_Exp_Mar Set Vlr_Contab_Ant   = Val_Con_Comp 
	Update Cta_Cte_Mas_Exp_Aer Set Vlr_Contab_Ant   = Val_Con_Comp
GO
