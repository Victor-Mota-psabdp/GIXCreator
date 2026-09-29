SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE pDetNF_Resumo_Rel 
(
@Num_Proc	VarChar(14) 
)
AS

	If left(@Num_Proc, 2) = 'IM' 
		Begin 
			select 
				Num_NF_MIM NF, Cte.Num_Proc_MIM Processo, Cte.DC_MIM DC, Nome_Tp_Tx Taxa, Vlr_Pgto_NF_MIM Valor_Taxa, Valor_Total, Nome_Raz_Soc
			From 
				Cta_cte_mas_imp_mar cte join base_nota_fiscal bnf on BNF.Nota_Fiscal = Cte.Num_NF_MIM and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_MIM 
				Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_MIM
			Where
				Cte.Num_Proc_MIM = @Num_Proc
				
			Union 
				
			select 
				Num_NF_HIM NF, Cte.Num_Proc_HIM Processo, Cte.DC_HIM DC, Nome_Tp_Tx Taxa, Vlr_Pgto_NF_HIM Valor_Taxa, Valor_Total, Nome_Raz_Soc
			From 
				Cta_cte_hou_imp_mar cte join base_nota_fiscal bnf on BNF.Nota_Fiscal = Cte.Num_NF_HIM and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_HIM 
				Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HIM
			Where
				Left(Cte.Num_Proc_HIM, 14) =   @Num_Proc
		End

	If left(@Num_Proc, 2) = 'IA' 
		Begin 
			select 
				Num_NF_MIA NF, Cte.Num_Proc_MIA Processo, Cte.DC_MIA DC, Nome_Tp_Tx Taxa, Vlr_Pgto_NF_MIA Valor_Taxa, Valor_Total, Nome_Raz_Soc
			From 
				Cta_cte_mas_imp_Aer cte join base_nota_fiscal bnf on BNF.Nota_Fiscal = Cte.Num_NF_MIA and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_MIA 
				Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_MIA
			Where
				Cte.Num_Proc_MIA = @Num_Proc
				
			Union 
				
			select 
				Num_NF_HIA NF, Cte.Num_Proc_HIA Processo, Cte.DC_HIA DC, Nome_Tp_Tx Taxa, Vlr_Pgto_NF_HIA Valor_Taxa, Valor_Total, Nome_Raz_Soc
			From 
				Cta_cte_hou_imp_Aer cte join base_nota_fiscal bnf on BNF.Nota_Fiscal = Cte.Num_NF_HIA and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_HIA 
				Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HIA
			Where
				Left(Cte.Num_Proc_HIA, 14) =   @Num_Proc
		End


	If left(@Num_Proc, 2) = 'EM' 
		Begin 
			select 
				Num_NF_MEM NF, Cte.Num_Proc_MEM Processo, Cte.DC_MEM DC, Nome_Tp_Tx Taxa, Vlr_Pgto_NF_MEM Valor_Taxa, Valor_Total, Nome_Raz_Soc
			From 
				Cta_cte_mas_exp_mar cte join base_nota_fiscal bnf on BNF.Nota_Fiscal = Cte.Num_NF_MEM and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_MEM 
				Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_MEM
			Where
				Cte.Num_Proc_MEM = @Num_Proc
				
			Union 
				
			select 
				Num_NF_HEM NF, Cte.Num_Proc_HEM Processo, Cte.DC_HEM DC, Nome_Tp_Tx Taxa, Vlr_Pgto_NF_HEM Valor_Taxa, Valor_Total, Nome_Raz_Soc
			From 
				Cta_cte_hou_exp_mar cte join base_nota_fiscal bnf on BNF.Nota_Fiscal = Cte.Num_NF_HEM and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_HEM 
				Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HEM
			Where
				Left(Cte.Num_Proc_HEM, 14) =   @Num_Proc
		End

	If left(@Num_Proc, 2) = 'EA' 
		Begin 
			select 
				Num_NF_MEA NF, Cte.Num_Proc_MEA Processo, Cte.DC_MEA DC, Nome_Tp_Tx Taxa, Vlr_Pgto_NF_MEA Valor_Taxa, Valor_Total, Nome_Raz_Soc
			From 
				Cta_cte_mas_exp_Aer cte join base_nota_fiscal bnf on BNF.Nota_Fiscal = Cte.Num_NF_MEA and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_MEA 
				Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_MEA
			Where
				Cte.Num_Proc_MEA = @Num_Proc
				
			Union 
				
			select 
				Num_NF_HEA NF, Cte.Num_Proc_HEA Processo, Cte.DC_HEA DC, Nome_Tp_Tx Taxa, Vlr_Pgto_NF_HEA Valor_Taxa, Valor_Total, Nome_Raz_Soc
			From 
				Cta_cte_hou_exp_Aer cte join base_nota_fiscal bnf on BNF.Nota_Fiscal = Cte.Num_NF_HEA and BNF.Ref_Acesso = Cte.Ref_Acesso_NF_HEA 
				Join Tipo_Taxa TT on TT.Cd_Tp_Tx = Cte.Cd_Tp_Tx 
				Join Pessoa Pes on Pes.Cd_Pes = Cte.Cd_Cred_Dev_HEA
			Where
				Left(Cte.Num_Proc_HEA, 14) =   @Num_Proc
		End
GO
