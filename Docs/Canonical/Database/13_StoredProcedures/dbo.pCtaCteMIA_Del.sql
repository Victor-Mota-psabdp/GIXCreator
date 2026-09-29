SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCteMIA_Del 
(
@Num_Proc_MIA		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_MIA			char(1),
@Org_Ins_MIA			varchar(9),
@Dt_Ins_MIA			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_MIA			Float, 
@Dt_Prev_Pgto_MIA		varchar(10), 
@Cd_Cred_Dev_MIA		varchar(10), 
@Desp_Dst_MIA		char(1),
@CPMF_MIA			char(1), 
@Comp_RP_MIA		char(1), 
@Comp_DN_MIA		char(1),
@Comp_CN_MIA		char(1),
@Comp_CPA_MIA		char(1), 
@Num_DCN_MIA		varchar(12)=Null, 
@Dt_Ctb_CC_MIA		varchar(10)=Null,
@Usuario			VarChar(6),
@IntDefinitiva			int=null
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
--(-4) Ja existe baixa - Impossível Excluir 
 AS
	Begin Transaction  
	Declare @NF VarChar(30) 
	Declare @Dt_Ins DateTime 
	Declare @Vlr_Contab	Decimal(12,2) 
	Declare @Grupo	varchar(10) 

	Set @NF = IsNull((Select  Num_NF_MIA From  Cta_Cte_Mas_Imp_Aer Where Num_Proc_MIA = @Num_Proc_MIA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIA = @DC_MIA ) , '') 
	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')
	If @NF <> '' 
		Begin 
			RollBack Transaction 
			Return -9 
		End 

	Set @Dt_Ins = (Select Convert(DateTime, Dt_Ins_MIA, 105) From Cta_Cte_Mas_Imp_Aer  Where Num_Proc_MIA = @Num_Proc_MIA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIA = @DC_MIA )	
	If (@Dt_Ins <> Dbo.Hoje(GetDate()) and  @Grupo <> 'ADMIN')
		Begin 
			RollBack Transaction 
			Return -10
		End 

	Set @Vlr_Contab = IsNull((Select Val_Con_Comp from Cta_Cte_Mas_Imp_Aer Where  Num_Proc_MIA = @Num_Proc_MIA and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MIA = @DC_MIA), 0)
--	If (@Vlr_Contab > 0 )
--		Begin 
--			RollBack Transaction 
--			Return -12
--		End 
	if @IntDefinitiva = 0 
		Set @Vlr_Contab =  null 



	If  Exists(Select Num_Proc_MIA from Cta_Cte_Mas_Imp_Aer Where  Num_Proc_MIA = @Num_Proc_MIA and Cd_Tp_Tx =@Cd_Tp_Tx and DC_MIA = @DC_MIA) 
		Begin 
			If Not Exists (Select  * From  Caixa_Mas_Imp_Aer Where Num_Proc_MIA = @Num_Proc_MIA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIA = @DC_MIA ) 
				Begin 
					Delete From 
						Cta_Cte_Mas_Imp_Aer
					Where 
						Num_Proc_MIA = @Num_Proc_MIA and 
						Cd_Tp_Tx = @Cd_Tp_Tx and 
						DC_MIA = @DC_MIA
					If @@RowCount  = 1  	
						Begin 
							Delete From 
								Cta_Cte_Hou_Imp_Aer
							Where 
								Num_Proc_HIA = left(@Num_Proc_MIA,14) and 
								Cd_Tp_Tx = @Cd_Tp_Tx and 
								DC_HIA = @DC_MIA
							Exec pLogCtaCte_Ins  
								'E', @Num_Proc_MIA, @Cd_Tp_Tx,@DC_MIA, @Org_Ins_MIA,@Dt_Ins_MIA, @Cd_Tp_Moeda, 
								@Vlr_Org_MIA, @Dt_Prev_Pgto_MIA,@Cd_Cred_Dev_MIA, @Desp_Dst_MIA,@CPMF_MIA,@Comp_RP_MIA, 
								@Comp_DN_MIA, @Comp_CN_MIA, @Comp_CPA_MIA, @Usuario , @Vlr_Contab
							If @@RowCount = 1 
								Begin 
									Commit Transaction
									Return 1 
								End 
							Else
								Begin 
									RollBack Transaction 
									Return -3 
								End 
						End 
					Else
						Begin 
							Rollback Transaction 
							Return - 2 
						End 
			
				End 
			Else
				Begin 
					Rollback Transaction 
					Return - 4 
				End 
		End 
	Else
		Begin 
			Rollback Transaction 
			Return - 1 
		End
GO
