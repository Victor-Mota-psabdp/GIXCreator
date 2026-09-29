SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


/****** Object:  Stored Procedure dbo.pCtaCteMIA_Sel    Script Date: 17/10/2002 07:32:48 ******/
CREATE PROCEDURE pCtaCteMIA_Sel 
(
@Num_Proc		VarChar(16) ='',
@RP_MIA		Char(1)=''
)
 AS
	If @RP_MIA = '' 
		Select  
			Num_Proc_MIA, 
			Nome_Tp_Tx_Ing,
			Cta_Cte_Mas_Imp_Aer.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			DC_MIA, 
			Org_Ins_MIA, 
			Dt_Ins_MIA, 
			Cta_Cte_Mas_Imp_Aer.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_MIA, 
			Dt_Prev_Pgto_MIA, 
			Cd_Cred_Dev_MIA, 
			Desp_Org_MIA,
			Apelido, 
			Desp_Org_MIA
			CPMF_MIA, 
			Comp_RP_MIA, 
			Comp_DN_MIA, 
			Comp_CN_MIA, 
			Comp_CPA_MIA
		From  	
			Cta_Cte_Mas_Imp_Aer, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 	
			Num_Proc_MIA = @Num_Proc AND 
			Cta_Cte_Mas_Imp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
			Cta_Cte_Mas_Imp_Aer.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
			Cd_Cred_Dev_MIA = Cd_Pes 
		Order by  
			Nome_Tp_Tx, DC_MIA
	Else 
		Select  
			Num_Proc_MIA, 
			Nome_Tp_Tx_Ing,
			Num_Proc_MIA + '-' + Cta_Cte_Mas_Imp_Aer.Cd_Tp_Tx + '-' + DC_MIA as Seq,
			Cta_Cte_Mas_Imp_Aer.Cd_Tp_Tx, 
			Nome_Tp_Tx, 
			DC_MIA, 
			Org_Ins_MIA, 
			Dt_Ins_MIA, 
			Cta_Cte_Mas_Imp_Aer.Cd_Tp_Moeda, 
			Nome_Tp_Moeda, 
			Vlr_Org_MIA, 
			Dt_Prev_Pgto_MIA, 
			Cd_Cred_Dev_MIA, 
			Desp_Org_MIA,
			Apelido, 
			CPMF_MIA, 
			Comp_RP_MIA, 
			Comp_DN_MIA, 
			Comp_CN_MIA, 
			Comp_CPA_MIA 
		From  	
			Cta_Cte_Mas_Imp_Aer, 
			Tipo_Taxa, 
			Tipo_Moeda, 
			Pessoa 
		Where 	
			Num_Proc_MIA = @Num_Proc AND 
			Cta_Cte_Mas_Imp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx AND 
			Cta_Cte_Mas_Imp_Aer.Cd_Tp_Moeda = Tipo_Moeda.Cd_Tp_Moeda AND 
			Cd_Cred_Dev_MIA = Cd_Pes And 
			Comp_RP_MIA = @RP_MIA
		Order by  
			Nome_Tp_Tx, DC_MIA



GO
