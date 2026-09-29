SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE pMIA_Sel 
(
@Num_Proc 	VarChar(14)
)
AS
	Select 
		Num_Proc_MIA, Dt_Emis_MIA, MAWB_MIA, Termo_MIA, Voo_MIA, Cd_Consig_MIA, Consig.Apelido as Consignatario,
		Cd_Export_MIA, Export.Apelido as Shipper, Cd_Org_MIA, Origem.Nome_Local as Origem, Cd_Dst_MIA, 
		Destino.Nome_Local as Destino, Dt_Cheg_MIA, Qtd_Tot_Vol_MIA, Peso_Bruto_MIA, Tp_Frete_MIA, 
		MIA.Cd_Tp_Moeda, TM.Nome_Tp_Moeda as Moeda, Vlr_Frete_MIA, Qtd_HAWB_MIA, Ref_Int_MIA, MIA.Nivel_DL, 
		Obs_MIA, DL.Perc_DL , CA.Nome_Cia_Aer, MIA.Cd_Cia_Aer
	From 
		Master_Imp_Aer as MIA Left Outer Join Pessoa as Consig on MIA.Cd_Consig_MIA = Consig.Cd_Pes 
		Left Outer Join Pessoa as Export on MIA.Cd_Export_MIA = Export.Cd_Pes 
		Left Outer Join Localidade as Origem on MIA.Cd_Org_MIA = Origem.Cd_local 
		Left Outer Join Localidade as Destino on MIA.Cd_Dst_MIA = Destino.Cd_local 
		Left Outer Join Tipo_Moeda as TM on MIA.Cd_Tp_Moeda = TM.Cd_Tp_Moeda 
		Left Outer Join Div_Lucro as DL on MIA.Nivel_DL = DL.Nivel_DL
		Left Outer Join Cia_Aerea CA on CA.Cd_Cia_Aer = MIA.Cd_Cia_Aer 
	Where
		MIA.Num_Proc_MIA = @Num_Proc
GO
