SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteMEM_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteMEM_Sel 
(
@Num_Proc		VarChar(14),
@RP_MEM		Char(1)=''
)
 AS
	If @RP_MEM = '' 
		Select  
			Num_Proc_MEM, 
			Cta_Cte_Mas_Exp_Mar.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			DC_MEM, 
			Org_Ins_MEM, 
			Dt_Ins_MEM, 
			Cta_Cte_Mas_Exp_Mar.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_MEM, 
			Dt_Prev_Pgto_MEM, 
			Cd_Cred_Dev_MEM, 
			Apelido, 
			Desp_Dst_MEM, 
			CPMF_MEM, 
			Comp_RP_MEM, 
			Comp_DN_MEM, 
			Comp_CN_MEM, 
			Comp_CPA_MEM
		From  	
			Cta_Cte_Mas_Exp_Mar, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 
			Num_Proc_MEM = @Num_Proc AND 
			Cta_Cte_Mas_Exp_Mar.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
			Cta_Cte_Mas_Exp_Mar.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
			Cd_Cred_Dev_MEM = Cd_Pes 
		Order by  
			Nome_Tp_Tx, DC_MEM
	Else
		Select  
			Num_Proc_MEM, 
			Nome_Tp_Tx_Ing,
			Num_Proc_MEM + '-' + Cta_Cte_Mas_Exp_Mar.Cd_Tp_Tx + '-' + DC_MEM as Seq,
			Cta_Cte_Mas_Exp_Mar.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			DC_MEM, 
			Org_Ins_MEM, 
			Dt_Ins_MEM, 
			Cta_Cte_Mas_Exp_Mar.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_MEM, 
			Dt_Prev_Pgto_MEM, 
			Cd_Cred_Dev_MEM, 
			Desp_Dst_MEM,
			Apelido, 
			Desp_Dst_MEM, 
			CPMF_MEM, 
			Comp_RP_MEM, 
			Comp_DN_MEM, 
			Comp_CN_MEM, 
			Comp_CPA_MEM 
		From  	
			Cta_Cte_Mas_Exp_Mar, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 	
			Num_Proc_MEM = @Num_Proc And 
			Cta_Cte_Mas_Exp_Mar.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx And
			Cta_Cte_Mas_Exp_Mar.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda And  
			Cd_Cred_Dev_MEM = Cd_Pes And
			Comp_RP_MEM = @RP_MEM
		Order by  
			Nome_Tp_Tx, DC_MEM



GO
