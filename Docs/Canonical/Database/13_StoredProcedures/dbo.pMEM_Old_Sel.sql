SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pMEM_Old_Sel    Script Date: 17/10/2002 07:32:50 ******/
CREATE PROCEDURE pMEM_Old_Sel 
(
@NumProc	VarChar(14)= '' 
)
 AS
If @NumProc <> '' 
	Select 
		Master.Num_Proc_MEM, Master.Dt_Emis_MEM, Master.Dt_Estuf_MEM, Master.Dt_Saida_MEM, 
		Master.MAWB_MEM, Master.Cd_Consig_MEM, Consig.Apelido AS ApelidoConsignat, 
		Master.Cd_Export_MEM, Ship.Apelido as ApelidoShipper, Master.Cd_Notify_MEM, 
		Notif.Apelido as ApelidoNotify, Master.Cd_Org_MEM, Orig.Nome_Local as LocalOrig, 
		Master.Cd_Dst_MEM, Dest.Nome_Local as LocalDest, Master.Trf_Net_MEM, Master.Qtd_Tot_Vol_MEM, 
		Master.Vol_Tot_MEM, Master.Peso_Bruto_MEM, Master.Tp_Frete_MEM, Master.Cd_Tp_Moeda, 
		Moeda.Nome_Tp_Moeda, Master.Vlr_Frete_MEM, Master.Qtd_HAWB_MEM, Master.Nivel_DL, 
		DL.Perc_DL, Obs_MEM 
	From 
		Master_exp_mar as Master, Pessoa AS Consig, Pessoa as Ship, Pessoa as Notif,
		Localidade as Orig, Localidade as Dest, Tipo_Moeda as Moeda, Div_Lucro as DL
	Where 	
		Master.Cd_Consig_MEM = Consig.Cd_Pes and Master.Cd_Export_MEM = Ship.Cd_pes and 
		Master.Cd_Notify_MEM = Notif.Cd_Pes and Master.Cd_Org_MEM = Orig.Cd_Local AND 
		Master.Cd_Dst_MEM = Dest.Cd_Local and Master.Cd_Tp_Moeda = Moeda.Cd_Tp_Moeda and 
		Master.Nivel_DL = DL.Nivel_DL and Master.Num_Proc_MEM = @NumProc
	Order by	 
		Master.Num_Proc_Mem
Else
	Select 
		Master.Num_Proc_MEM, Master.Dt_Emis_MEM, Master.Dt_Estuf_MEM, Master.Dt_Saida_MEM, 
		Master.MAWB_MEM, Master.Cd_Consig_MEM, Consig.Apelido AS ApelidoConsignat, 
		Master.Cd_Export_MEM, Ship.Apelido as ApelidoShipper, Master.Cd_Notify_MEM, 
		Notif.Apelido as ApelidoNotify, Master.Cd_Org_MEM, Orig.Nome_Local as LocalOrig, 
		Master.Cd_Dst_MEM, Dest.Nome_Local as LocalDest, Master.Trf_Net_MEM, Master.Qtd_Tot_Vol_MEM, 
		Master.Vol_Tot_MEM, Master.Peso_Bruto_MEM, Master.Tp_Frete_MEM, Master.Cd_Tp_Moeda, 
		Moeda.Nome_Tp_Moeda, Master.Vlr_Frete_MEM, Master.Qtd_HAWB_MEM, Master.Nivel_DL, 
		DL.Perc_DL, Obs_MEM 
	From 
		Master_exp_mar as Master, Pessoa AS Consig, Pessoa as Ship, Pessoa as Notif,
		Localidade as Orig, Localidade as Dest, Tipo_Moeda as Moeda, Div_Lucro as DL
	Where 	
		Master.Cd_Consig_MEM = Consig.Cd_Pes and Master.Cd_Export_MEM = Ship.Cd_pes and 
		Master.Cd_Notify_MEM = Notif.Cd_Pes and Master.Cd_Org_MEM = Orig.Cd_Local AND 
		Master.Cd_Dst_MEM = Dest.Cd_Local and Master.Cd_Tp_Moeda = Moeda.Cd_Tp_Moeda and 
		Master.Nivel_DL = DL.Nivel_DL 
	Order by	 
		Master.Num_Proc_Mem



GO
