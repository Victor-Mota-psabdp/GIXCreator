SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE pCtaCteHIA_Sel 
(
@Num_Proc		VarChar(16) ='',
@CreditNote		VarChar(12) ='',
@RP_HIA		Char(1)=''
)
 AS
	If @CreditNote <> '' 
		Begin 
			Select  
				Nome_Tp_Tx_Ing, 
				DC_HIA, 
				Cd_Tp_Moeda, 
				Vlr_Org_HIA
			From  	
				Cta_Cte_Hou_Imp_Aer, 
				Tipo_Taxa 
			Where 	
				Cta_Cte_Hou_Imp_Aer.Cd_Tp_Tx = Tipo_Taxa.Cd_Tp_Tx  and
				Num_DCN_HIA = @CreditNote and 
				Num_Proc_HIA = @Num_Proc 
			Order by  
				Cd_Tp_Moeda, 			
				Nome_Tp_Tx_Ing
		End 
	Else
		Begin 
			If @RP_HIA = '' 
				Begin 
					Select  
						Num_Proc_HIA, 
						Nome_Tp_Tx_Ing,
						Cte.Cd_Tp_Tx, 
						Nome_Tp_Tx, 
						DC_HIA, 
						Org_Ins_HIA, 
						Dt_Ins_HIA, 
						Cte.Cd_Tp_Moeda, 
						Nome_Tp_Moeda, 
						Vlr_Org_HIA, 
						Dt_Prev_Pgto_HIA, 
						Cd_Cred_Dev_HIA, 
						Desp_Org_HIA,
						Apelido, 
						Desp_Org_HIA,
						Cte.CPMF_HIA, 
						Comp_RP_HIA, 
						Comp_DN_HIA, 
						Comp_CN_HIA, 
						Comp_CPA_HIA, 
						Num_DCN_HIA,
						Dt_Ctb_CC_HIA
					From  	
						Cta_Cte_Hou_Imp_Aer Cte Join  Tipo_Taxa TT  on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx  
						join Tipo_Moeda TM on TM.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda  
						join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HIA
					Where 	
						Num_Proc_HIA = @Num_Proc  
					Order by  
						Nome_Tp_Tx, DC_HIA
				End 
			Else 
				Begin 
					Select  
						Num_Proc_HIA, 
						Nome_Tp_Tx_Ing,
						Num_Proc_HIA + '-' + Cte.Cd_Tp_Tx + '-' + DC_HIA as Seq,
						Cte.Cd_Tp_Tx, 
						Nome_Tp_Tx, 
						DC_HIA, 
						Org_Ins_HIA, 
						Dt_Ins_HIA, 
						Cte.Cd_Tp_Moeda, 
						Nome_Tp_Moeda, 
						Vlr_Org_HIA, 
						Dt_Prev_Pgto_HIA, 
						Cd_Cred_Dev_HIA, 
						Desp_Org_HIA,
						Apelido, 
						Cte.CPMF_HIA, 
						Comp_RP_HIA, 
						Comp_DN_HIA, 
						Comp_CN_HIA, 
						Comp_CPA_HIA, 
						Num_DCN_HIA,
						Dt_Ctb_CC_HIA
					From  	
						Cta_Cte_Hou_Imp_Aer Cte Join  Tipo_Taxa TT  on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx  
						join Tipo_Moeda TM on TM.Cd_Tp_Moeda = Cte.Cd_Tp_Moeda  
						join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HIA 
					Where 	
						Num_Proc_HIA = @Num_Proc AND 
						Comp_RP_HIA = @RP_HIA
					Order by  
						Nome_Tp_Tx, DC_HIA
				End
		End
GO
