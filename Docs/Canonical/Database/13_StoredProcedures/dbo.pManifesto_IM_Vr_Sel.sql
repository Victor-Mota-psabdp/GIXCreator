SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE  PROCEDURE pManifesto_IM_Vr_Sel
(
@Master		VarChar(30),
@IdViagem		Int, 
@Tp_Manif		Char(1)
)
AS
If @Tp_Manif = 'M'	
	Select 
		HIM.HAWB_HIM as House, Consig.Nome_Raz_Soc as Consignatario, HIM.Cd_Tp_Moeda,
		Vlr_Frete_Efet_HIM as Frete, 
		HIM.Qtd_Tot_Vol_HIM as Quantidade,
		TE.Nome_Tp_Embal as Embalagem,
		Peso_Bruto_HIM as Peso_Bruto
	From 
		House_Imp_Mar as HIM Join Pessoa as Consig on Consig.Cd_Pes = HIM.Cd_Consig_HIM
		Left Outer Join Volume_Imp_Mar as VIM on VIM.Num_Proc_HIM = HIM.Num_Proc_HIM and Item_IM = '01'
		Left Outer Join Tipo_Embalagem as TE on TE.Cd_Tp_Embal = HIM.Cd_Tp_Embal 
		--Left Outer Join Volume_Imp_Mar as VIMT on VIMT.Num_Proc_HIM = HIM.Num_Proc_HIM
	Where
		HIM.Num_Proc_HIM in 
		(Select Num_Proc_HIM From House_Imp_Mar as HIM Join Master_Imp_Mar as MIM on HIM.Num_Proc_MIM = MIM.Num_Proc_MIM Where MIM.MAWB_MIM = @Master and MIM.Id_Viagem = @IdViagem)

Else
	Select 
		HIM.HAWB_HIM as House, Consig.Nome_Raz_Soc as Consignatario, HIM.Cd_Tp_Moeda,
		Vlr_Frete_Efet_HIM as Frete, 
		HIM.Qtd_Tot_Vol_HIM as Quantidade,
		TE.Nome_Tp_Embal as Embalagem,
		Peso_Bruto_HIM as Peso_Bruto
	From 
		House_Imp_Mar as HIM Join Pessoa as Consig on Consig.Cd_Pes = HIM.Cd_Consig_HIM
		Left Outer Join Volume_Imp_Mar as VIM on VIM.Num_Proc_HIM = HIM.Num_Proc_HIM and Item_IM = '01'
		Left Outer Join Tipo_Embalagem as TE on TE.Cd_Tp_Embal = HIM.Cd_Tp_Embal 
		--Left Outer Join Volume_Imp_Mar as VIMT on VIMT.Num_Proc_HIM = HIM.Num_Proc_HIM
	Where
		HIM.Num_Proc_HIM in 
		(Select Num_Proc_HIM From House_Imp_Mar as HIM Join Master_Imp_Mar as MIM on HIM.Num_Proc_MIM = MIM.Num_Proc_MIM Where MIM.Sub_Master_Col_MIM =  @Master and MIM.Id_Viagem = @IdViagem)
GO
