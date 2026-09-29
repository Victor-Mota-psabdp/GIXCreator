SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteMIM_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteMIM_Sel 
(
@Num_Proc		VarChar(14), 
@RP_MIM		Char(1)=''
)
 AS
	If @RP_MIM = '' 
		Select  
			Num_Proc_MIM, 
			Cta_Cte_Mas_Imp_Mar.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			DC_MIM, 
			Org_Ins_MIM, 
			Dt_Ins_MIM, 
			Cta_Cte_Mas_Imp_Mar.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_MIM, 
			Dt_Prev_Pgto_MIM, 
			Cd_Cred_Dev_MiM, 
			Apelido, 
			Desp_Org_MIM, 
			CPMF_MIM, 
			Comp_RP_MIM, 
			Comp_DN_MIM, 
			Comp_CN_MIM, 
			Comp_CPA_MIM
		From  	
			Cta_Cte_Mas_Imp_Mar, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 
			Num_Proc_MIM = @Num_Proc AND 
			Cta_Cte_Mas_Imp_Mar.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
			Cta_Cte_Mas_Imp_Mar.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
			Cd_Cred_Dev_MIM = Cd_Pes 
		Order by  
			Nome_Tp_Tx, DC_MIM
	Else
		Select  
			Num_Proc_MIM, 
			Cta_Cte_Mas_Imp_Mar.Cd_Tp_Tx, 
			Num_Proc_MIM + '-' + Cta_Cte_Mas_Imp_Mar.Cd_Tp_Tx + '-' + DC_MIM as Seq,
			Nome_Tp_Tx, 
			DC_MIM, 
			Org_Ins_MIM, 
			Dt_Ins_MIM, 
			Cta_Cte_Mas_Imp_Mar.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_MIM, 
			Dt_Prev_Pgto_MIM, 
			Cd_Cred_Dev_MIM, 
			Apelido, 
			Desp_Org_MIM, 
			CPMF_MIM, 
			Comp_RP_MIM, 
			Comp_DN_MIM, 
			Comp_CN_MIM, 
			Comp_CPA_MIM
		From  	
			Cta_Cte_Mas_Imp_Mar, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 
			Cta_Cte_Mas_Imp_Mar.Num_Proc_MIM = @Num_Proc and 
			Cta_Cte_Mas_Imp_Mar.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx and  
			Cta_Cte_Mas_Imp_Mar.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda and  
			Cd_Cred_Dev_MIM = Cd_Pes and 
			Comp_RP_MIM = @RP_MIM
			
		Order by  
			Nome_Tp_Tx, DC_MIM



GO
