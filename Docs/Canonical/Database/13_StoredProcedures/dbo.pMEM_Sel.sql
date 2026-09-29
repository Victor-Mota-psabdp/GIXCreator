SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pMEM_Sel 
(
@NumProc	VarChar(14)= '' 
)
 AS
If @NumProc <> '' 
	Select 
		Master.Num_Proc_MEM, Master.Dt_Emis_MEM, Master.Dt_Estuf_MEM, Master.Dt_Saida_MEM, 
		Master.MAWB_MEM, Master.Cd_Consig_MEM, Consig.Apelido AS ApelidoConsignat, 
		Consig.Nome_Raz_Soc as Raz_Soc_Consignat,Master.Cd_Export_MEM, Ship.Apelido as ApelidoShipper, 
		Master.Cd_Notify_MEM, 	Notif.Apelido as ApelidoNotify, Master.Cd_Org_MEM, Orig.Nome_Local as LocalOrig, 
		Master.Cd_Dst_MEM, Dest.Nome_Local as LocalDest, Master.Trf_Net_MEM, Master.Qtd_Tot_Vol_MEM, 
		Master.Vol_Tot_MEM, Master.Peso_Bruto_MEM, Master.Tp_Frete_MEM, Master.Cd_Tp_Moeda, 
		Moeda.Nome_Tp_Moeda, Master.Vlr_Frete_MEM, Master.Qtd_HAWB_MEM, Master.Nivel_DL, 
		DL.Perc_DL, Obs_MEM,
		Vg.ID_Viagem, Vg.Nr_Viagem,  Vg.Ano_Viagem, Vg.Dt_Previs, Vg.Dt_Atrac, Vg.ID_Navio, 
		Vg.ID_Loc_Atrac, Vg.Dt_Oper, Vg.Nr_Viagem_Age, Nv.Nome_Navio, Nv.LLoyd,
		Arm.Nome_Armador, Term.Nome_Terminal, Term.Cd_Repart, Term.Cd_Term_Ofc , ETD_MEM, ETA_MEM
	From 
		Master_exp_mar as Master 
		Left Outer Join Pessoa as Consig on Master.Cd_Consig_MEM = Consig.Cd_Pes 
		Left Outer Join Pessoa as Ship on Master.Cd_Export_MEM = Ship.Cd_pes 
		Left Outer Join Pessoa as Notif on Master.Cd_Notify_MEM = Notif.Cd_Pes 
		Join Localidade as Orig on Master.Cd_Org_MEM = Orig.Cd_Local 
		Join Localidade as Dest on Master.Cd_Dst_MEM = Dest.Cd_Local 
		Left Outer Join Tipo_Moeda as Moeda on Master.Cd_Tp_Moeda = Moeda.Cd_Tp_Moeda 
		Left Outer Join Div_Lucro as DL on Master.Nivel_DL = DL.Nivel_DL  
		Left Outer Join Viagem as Vg on Master.ID_Viagem = Vg.ID_Viagem 
		Left Outer Join Navio as NV on Vg.ID_Navio = NV.ID_Navio
		Left Outer Join Armador as Arm on Master.Cd_Armador = Arm.Cd_Armador 
		Left Outer Join Terminal as Term on Master.Cd_Terminal = Term.Cd_Terminal 
	Where 	
		Master.Num_Proc_MEM = @NumProc
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
		DL.Perc_DL, Obs_MEM,
		Vg.ID_Viagem, Vg.Nr_Viagem,  Vg.Ano_Viagem, Vg.Dt_Previs, Vg.Dt_Atrac, Vg.ID_Navio, 
		Vg.ID_Loc_Atrac, Vg.Dt_Oper, Vg.Nr_Viagem_Age, Nv.Nome_Navio, Nv.LLoyd,
		Arm.Nome_Armador
	From 
		Master_Exp_mar as Master
		Left Outer Join Pessoa as Consig on Master.Cd_Consig_MEM = Consig.Cd_Pes 
		Left Outer Join Pessoa as Ship on Master.Cd_Export_MEM = Ship.Cd_pes 
		Left Outer Join Pessoa as Notif on Master.Cd_Notify_MEM = Notif.Cd_Pes 
		Join Localidade as Orig on Master.Cd_Org_MEM = Orig.Cd_Local 
		Join Localidade as Dest on Master.Cd_Dst_MEM = Dest.Cd_Local 
		Join Tipo_Moeda as Moeda on Master.Cd_Tp_Moeda = Moeda.Cd_Tp_Moeda 
		Join Div_Lucro as DL on Master.Nivel_DL = DL.Nivel_DL 
		Left Outer Join Viagem as Vg on Master.ID_Viagem = Vg.ID_Viagem 
		Left Outer Join Navio as NV on Vg.ID_Navio = NV.ID_Navio
		Left Outer Join Armador as Arm on Master.Cd_Armador = Arm.Cd_Armador 
	Order by	 
		Master.Num_Proc_Mem

GO
