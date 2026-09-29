SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteMEA_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteMEA_Sel 
(
@Num_Proc		VarChar(16) ='',
@RP_MEA		Char(1)=''
)
 AS
	If @RP_MEA = ''		
		Select  
			Num_Proc_MEA, 
			Nome_Tp_Tx_Ing,
			Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			DC_MEA, 
			Org_Ins_MEA, 
			Dt_Ins_MEA, 
			Cta_Cte_Mas_Exp_Aer.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_MEA, 
			Dt_Prev_Pgto_MEA, 
			Cd_Cred_Dev_MEA, 
			Desp_Dst_MEA,
			Apelido, 
			Desp_Dst_MEA, 
			CPMF_MEA, 
			Comp_RP_MEA, 
			Comp_DN_MEA, 
			Comp_CN_MEA, 
			Comp_CPA_MEA,
			Comp_MBL_MEA 
		From  	
			Cta_Cte_Mas_Exp_Aer, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 	
			Num_Proc_MEA = @Num_Proc AND 
			Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
			Cta_Cte_Mas_Exp_Aer.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
			Cd_Cred_Dev_MEA = Cd_Pes 
		Order by  
			Nome_Tp_Tx, DC_MEA
	Else
		Select  
			Num_Proc_MEA, 
			Nome_Tp_Tx_Ing,
			Num_Proc_MEA + '-' + Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx + '-' + DC_MEA as Seq,
			Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			DC_MEA, 
			Org_Ins_MEA, 
			Dt_Ins_MEA, 
			Cta_Cte_Mas_Exp_Aer.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_MEA, 
			Dt_Prev_Pgto_MEA, 
			Cd_Cred_Dev_MEA, 
			Desp_Dst_MEA,
			Apelido, 
			Desp_Dst_MEA, 
			CPMF_MEA, 
			Comp_RP_MEA, 
			Comp_DN_MEA, 
			Comp_CN_MEA, 
			Comp_CPA_MEA,
			Comp_MBL_MEA
		From  	
			Cta_Cte_Mas_Exp_Aer, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 	
			Num_Proc_MEA = @Num_Proc And 
			Cta_Cte_Mas_Exp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx And 
			Cta_Cte_Mas_Exp_Aer.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda And 
			Cd_Cred_Dev_MEA = Cd_Pes And 
			Comp_RP_MEA = @RP_MEA
		Order by  
			Nome_Tp_Tx, DC_MEA

GO
