SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE  PROCEDURE pMIM_Sel
(
@Num_Proc 	VarChar(14) =''
)
 AS
	If @Num_Proc <> ''
		Select 
			Num_Proc_MIM, Dt_Emis_MIM, Dt_Saida_MIM, Dt_Atrac_MIM, Dt_Oper_MIM, Dt_Desova_MIM, 
			Dt_Rcb_MIM, Dt_Reg_Alf_MIM, Reg_Alf_MIM, CIMC_MIM, MAWB_MIM, Sub_Master_MIM, 
			Sub_Master_Col_MIM, Cd_Consig_MIM, Consignat.Apelido as Consignatario, Cd_Export_MIM, 
			Ship.Apelido as Shipper, Cd_Org_MIM, Orig.Nome_Local as Origem, Cd_Dst_MIM, 
			Dest.Nome_Local as Destino, MIM.Cd_Armador, ArmMast.Nome_Armador as Armador, 
			Cd_Armador_SM, ArmSubM.Nome_Armador as ArmadorSubM, Cd_Transb_MIM, Transb.Nome_Local as PortoTransb, 
			Navio_Transb_MIM, Navio_MIM, Viagem_MIM, IRIN_MIM, Cod_Rec_MIM, MIM.Cd_Armazem, 
			Nome_Armazem, MIM.Cd_Terminal, Nome_Terminal, Qtd_Tot_Vol_MIM, 
			Vol_Tot_MIM, Peso_Bruto_MIM, Tp_Frete_MIM, MIM.Cd_Tp_Moeda, Nome_Tp_Moeda, 
			Vlr_Frete_MIM, Qtd_HAWB_MIM, Ref_Int_MIM, MIM.Nivel_DL, Perc_DL, Obs_MIM,
			Vg.ID_Viagem, Vg.Nr_Viagem,  Vg.Ano_Viagem, Vg.Dt_Previs, Vg.Dt_Atrac, Vg.ID_Navio, 
			Vg.ID_Loc_Atrac, Vg.Dt_Oper, Vg.Nr_Viagem_Age, Nv.Nome_Navio, Nv.LLoyd, 
			Atrac.Nome_Loc_Atrac, Dt_Ent_Term, Dt_Lib_Bl, AWB, Dt_Rec_Doc, Dt_Doc_Camb, 
			Vg.Dt_Previs ETA , DtRedest_MIM
		From 
			Master_Imp_Mar as MIM Left Outer Join Pessoa as Consignat on Cd_Consig_MIM = Consignat.Cd_Pes  
			Left Outer Join Pessoa as Ship on Cd_Export_MIM = Ship.Cd_Pes 
			Join Localidade as Orig on Cd_Org_MIM = Orig.Cd_Local 
			Join Localidade as Dest on Cd_Dst_MIM = Dest.Cd_Local 
			Left Outer Join Armador as ArmMast on MIM.Cd_Armador = ArmMast.Cd_Armador 
			Left Outer Join Armador as ArmSubM on MIM.Cd_Armador_SM =ArmSubM.Cd_Armador 
			Left Outer Join Localidade as Transb on Cd_Transb_MIM = Transb.Cd_Local 
			Left Outer Join Armazem on MIM.Cd_Armazem = Armazem.Cd_Armazem  
			Left Outer Join Terminal on MIM.Cd_Terminal = Terminal.Cd_Terminal
			Left Outer Join Tipo_Moeda  on MIM.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda
			Left Outer Join Div_Lucro on MIM.Nivel_DL = Div_Lucro.Nivel_DL 
			Left Outer Join Viagem as Vg on MIM.ID_Viagem = Vg.ID_Viagem 
			Left Outer Join Navio as NV on Vg.ID_Navio = NV.ID_Navio
			Left Outer Join Locais_Atrac as Atrac on Vg.ID_Loc_Atrac = Atrac.ID_Loc_Atrac
		Where 
			MIM.Num_Proc_MIM = @Num_Proc 
		Order by  
			Num_Proc_MIM
	Else
		Select 
			Num_Proc_MIM, Dt_Emis_MIM, Dt_Saida_MIM, Dt_Atrac_MIM, Dt_Oper_MIM, Dt_Desova_MIM, 
			Dt_Rcb_MIM, Dt_Reg_Alf_MIM, Reg_Alf_MIM, CIMC_MIM, MAWB_MIM, Sub_Master_MIM, 
			Sub_Master_Col_MIM, Cd_Consig_MIM, Consignat.Apelido as Consignatario, Cd_Export_MIM, 
			Ship.Apelido as Shipper, Cd_Org_MIM, Orig.Nome_Local as Origem, Cd_Dst_MIM, 
			Dest.Nome_Local as Destino, MIM.Cd_Armador, ArmMast.Nome_Armador as Armador, 
			Cd_Armador_SM, ArmSubM.Nome_Armador as ArmadorSubM, Cd_Transb_MIM, Transb.Nome_Local as PortoTransb, 
			Navio_Transb_MIM, Navio_MIM, Viagem_MIM, IRIN_MIM, Cod_Rec_MIM, MIM.Cd_Armazem, 
			Nome_Armazem, MIM.Cd_Terminal, Nome_Terminal, Qtd_Tot_Vol_MIM, 
			Vol_Tot_MIM, Peso_Bruto_MIM, Tp_Frete_MIM, MIM.Cd_Tp_Moeda, Nome_Tp_Moeda, 
			Vlr_Frete_MIM, Qtd_HAWB_MIM, Ref_Int_MIM, MIM.Nivel_DL, Perc_DL, Obs_MIM,
			Vg.ID_Viagem, Vg.Nr_Viagem,  Vg.Ano_Viagem, Vg.Dt_Previs, Vg.Dt_Atrac, Vg.ID_Navio, 
			Vg.ID_Loc_Atrac, Vg.Dt_Oper, Vg.Nr_Viagem_Age, Nv.Nome_Navio, Nv.LLoyd, 
			Atrac.Nome_Loc_Atrac, Dt_Ent_Term, Dt_Lib_Bl, AWB, Dt_Rec_Doc, Dt_Doc_Camb,Vg.Dt_Previs ETA 
		From 
			Master_Imp_Mar as MIM Left Outer Join Pessoa as Consignat on Cd_Consig_MIM = Consignat.Cd_Pes  
			Left Outer Join Pessoa as Ship on Cd_Export_MIM = Ship.Cd_Pes 
			Join Localidade as Orig on Cd_Org_MIM = Orig.Cd_Local 
			Join Localidade as Dest on Cd_Dst_MIM = Dest.Cd_Local 
			Left Outer Join Armador as ArmMast on MIM.Cd_Armador = ArmMast.Cd_Armador 
			Left Outer Join Armador as ArmSubM on MIM.Cd_Armador_SM =ArmSubM.Cd_Armador 
			Left Outer Join Localidade as Transb on Cd_Transb_MIM = Transb.Cd_Local 
			Left Outer Join Armazem on MIM.Cd_Armazem = Armazem.Cd_Armazem  
			Left Outer Join Terminal on MIM.Cd_Terminal = Terminal.Cd_Terminal
			Left Outer Join Tipo_Moeda  on MIM.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda
			Left Outer Join Div_Lucro on MIM.Nivel_DL = Div_Lucro.Nivel_DL
			Left Outer Join Viagem as Vg on MIM.ID_Viagem = Vg.ID_Viagem 
			Left Outer Join Navio as NV on Vg.ID_Navio = NV.ID_Navio
			Left Outer Join Locais_Atrac as Atrac on Vg.ID_Loc_Atrac = Atrac.ID_Loc_Atrac
		Order by  
			Num_Proc_MIM
GO
