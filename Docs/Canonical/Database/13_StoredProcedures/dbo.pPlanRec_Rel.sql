SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE  PROCEDURE pPlanRec_Rel 
(
@CredDev	VarChar(10)='%', 
@Data1	DateTime, 
@Data2	DateTime 
) 
AS
	Select 
		'IM' as Modal, HIM.HAWB_HIM as House, HIM.Num_Proc_HIM as Processo, MIM.MAWB_MIM as Master, 
		MIM.Navio_MIM as Navio, MIM.Dt_Oper_MIM as Dt_Oper, 
		Term.Nome_Terminal as Terminal, MIM.Dt_Saida_MIM as Saida, 
		CredDev.Apelido as CredDev, TT.Nome_Tp_Tx as Taxa, Cte.Cd_Tp_Moeda, 
		Cte.Vlr_Org_HIM, Par.Par_Moeda as Paridade, Arm.Nome_Armador as Armador,
		MIM.Cd_Tp_Moeda as Moeda_Frete, HIM.Vlr_Frete_Efet_HIM as Frete,
		Par_Moeda as Paridade, Sum(Cxa.Vlr_Ref_HIM)  as Vlr_Ref,
		Sum(Vlr_Pgto_Rcto_HIM) as Vlr_Pago 
	From 
		House_Imp_Mar as HIM Join Master_Imp_Mar as MIM on MIM.Num_Proc_MIM = HIM.Num_Proc_MIM 
		Join Cta_Cte_Hou_Imp_Mar as Cte on Cte.Num_Proc_HIM = HIM.Num_Proc_HIM 
		Left Outer Join Caixa_Hou_Imp_Mar as Cxa on Cxa.Num_Proc_HIM = Cte.Num_Proc_HIM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_HIM = Cte.DC_HIM 
		JOin Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Pessoa as CredDev on CredDev.Cd_Pes = Cte.Cd_Cred_Dev_HIM 
		Join Tipo_Moeda as TM on TM.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda 
		Left Outer Join Paridade as Par on (Par.Cd_Tp_Par = 'IMM' and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Convert(Datetime, Dt_Par, 105) = dbo.Hoje(Getdate()))
		Left Outer Join Armador as Arm on Arm.Cd_Armador = MIM.Cd_Armador 
		Left Outer Join Terminal as Term on Term.Cd_Terminal = MIM.Cd_Terminal 
	Where
		Convert(Datetime, MIM.Dt_Atrac_MIM, 105) between @data1 and @Data2 and 
		CredDev.Apelido like @CredDev and 
		Cte.Desp_Org_HIM = 'N' and Cte.Comp_RP_HIM = 'S' and 
		Cte.Cd_Tp_Tx <> 'PBD' and Cte.Cd_Tp_Tx <> 'PSA' and Cte.DC_HIM = 'C' and 
		Left(HIM.Num_Proc_HIM, 5) <> 'IMJOB'
	Group By 
		HIM.HAWB_HIM, HIM.Num_Proc_HIM, MIM.MAWB_MIM, MIM.Navio_MIM, MIM.Dt_Oper_MIM, 
		Term.Nome_Terminal, MIM.Dt_Saida_MIM, CredDev.Apelido, 
		TT.Nome_Tp_Tx, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HIM, Par.Par_Moeda,
		Arm.Nome_Armador,MIM.Cd_Tp_Moeda, HIM.Vlr_Frete_Efet_HIM , Par_Moeda

	Union 

	Select 
		'EM' as Modal, HEM.HAWB_HEM as House, HEM.Num_Proc_HEM as Processo, MEM.MAWB_MEM as Master, 
		HEM.Navio_HEM as Navio, '' as Dt_Oper, 
		Term.Nome_Terminal as Terminal, MEM.Dt_Saida_MEM as Saida, 
		CredDev.Apelido as CredDev, TT.Nome_Tp_Tx as Taxa, Cte.Cd_Tp_Moeda, 
		Cte.Vlr_Org_HEM, Par.Par_Moeda as Paridade, Arm.Nome_Armador as Armador,
		MEM.Cd_Tp_Moeda as Moeda_Frete, MEM.Vlr_Frete_MEM as Frete,
		Par_Moeda as Paridade, Sum(Cxa.Vlr_Ref_HEM)  as Vlr_Ref,
		Sum(Vlr_Pgto_Rcto_HEM) as Vlr_Pago
	From 
		House_Exp_Mar as HEM Join Master_Exp_Mar as MEM on MEM.Num_Proc_MEM = HEM.Num_Proc_MEM 
		Join Cta_Cte_Hou_Exp_Mar as Cte on Cte.Num_Proc_HEM = HEM.Num_Proc_HEM 
		Left Outer Join Caixa_Hou_Exp_Mar as Cxa on Cxa.Num_Proc_HEM = Cte.Num_Proc_HEM and Cxa.Cd_Tp_Tx = Cte.Cd_Tp_Tx and Cxa.DC_HEM = Cte.DC_HEM 
		Join Tipo_Taxa as TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
		Join Pessoa as CredDev on CredDev.Cd_Pes = Cte.Cd_Cred_Dev_HEM 
		Join Tipo_Moeda as TM on TM.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda 
		Left Outer Join Paridade as Par on (Par.Cd_Tp_Par = 'EXM' and Par.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda and Convert(Datetime, Dt_Par, 105) = dbo.Hoje(Getdate()))
		Left Outer Join Armador as Arm on Arm.Cd_Armador = MEM.Cd_Armador 
		Left Outer Join Terminal as Term on Term.Cd_Terminal = MEM.Cd_Terminal 
	Where
		Convert(Datetime, MEM.Dt_Saida_MEM, 105) between @data1 and @Data2 and 
		CredDev.Apelido like @CredDev and 
		Cte.Desp_Dst_HEM = 'N' and Cte.Comp_RP_HEM = 'S' and 
		Cte.Cd_Tp_Tx <> 'PBD' and Cte.Cd_Tp_Tx <> 'PSA' and Cte.DC_HEM = 'C' and 
		Left(HEM.Num_Proc_HEM, 5) <> 'EMJOB'
	Group By 
		HEM.HAWB_HEM, HEM.Num_Proc_HEM, MEM.MAWB_MEM, HEM.Navio_HEM, 
		Term.Nome_Terminal, MEM.Dt_Saida_MEM, CredDev.Apelido, 
		TT.Nome_Tp_Tx, Cte.Cd_Tp_Moeda, Cte.Vlr_Org_HEM, Par.Par_Moeda,
		Arm.Nome_Armador,MEM.Cd_Tp_Moeda, MEM.Vlr_Frete_MEM, 
		Par_Moeda


GO
