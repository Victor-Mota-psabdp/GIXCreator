SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pCtaCteMIM_Upd
(
@Num_Proc_MIM		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_MIM			char(1),
@Org_Ins_MIM			varchar(9),
@Dt_Ins_MIM			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_MIM			Float, 
@Dt_Prev_Pgto_MIM		varchar(10), 
@Cd_Cred_Dev_MIM		varchar(10), 
@Desp_Org_MIM		char(1),
@CPMF_MIM			char(1), 
@Comp_RP_MIM		char(1), 
@Comp_DN_MIM		char(1),
@Comp_CN_MIM		char(1),
@Comp_CPA_MIM		char(1),
@Num_DCN_MIM		varchar(12)=Null, 
@Dt_Ctb_CC_MIM		varchar(10)=Null,
@Usuario			Varchar(6),
@IntDefinitiva			int=null
)
--Parâmetros de Retorno 
--(-5)  Erro no procedimento de Deleção 
 AS
	Declare @Retorno integer 
	Declare @NF VarChar(30) 
	Declare @Dt_Ins DateTime
	Declare @Grupo	VarChar(20) 
	Declare @Vlr_Contab 	Decimal(12,2) 

	Set @Grupo = (Select Grupo From Usuario Where Cd_Usuario = @Usuario)

	Begin Transaction 
	Set @NF = IsNull((Select  Num_NF_MIM From  Cta_Cte_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIM = @DC_MIM ) , '') 
	Set @Vlr_Contab = IsNull((Select  Val_Con_Comp From  Cta_Cte_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIM = @DC_MIM ) , 0)

	If @NF <> '' 
		Begin 
			RollBack Transaction 
			Return -9 
		End 

	Set @Dt_Ins = (Select Convert(DateTime, Dt_Ins_MIM, 105) From Cta_Cte_Mas_Imp_Mar  Where Num_Proc_MIM = @Num_Proc_MIM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIM = @DC_MIM )	
	If (@Dt_Ins <> Dbo.Hoje(GetDate()) and  @Grupo <> 'ADMIN')
		Begin 
			RollBack Transaction 
			Return -10
		End 

	If (@Vlr_Contab > 0  )
		Begin 
			RollBack Transaction 
			Return -12
		End 


	If @DC_MIM = 'D' and @Cd_Tp_Tx in (Select Cd_Tp_Tx From Tipo_Taxa Where Pft_Aer = 'S') and @Grupo <>'ADMIN'
		Begin
			RollBack Transaction 
			Return - 33
		End 


	If  Not Exists (Select * From Caixa_Mas_Imp_Mar Where Num_Proc_MIM = @Num_Proc_MIM and Cd_Tp_Tx = @Cd_Tp_Tx and  DC_MIM = @DC_MIM)
		Begin 
			Update 
				Cta_Cte_Mas_Imp_Mar
			Set 
				Cd_Tp_Tx= @Cd_Tp_Tx,
				DC_MIM = @DC_MIM,
				Org_Ins_MIM = @Org_Ins_MIM,
				--Dt_Ins_MIM = @Dt_Ins_MIM,
				Cd_Tp_Moeda = @Cd_Tp_Moeda,
				Vlr_Org_MIM = @Vlr_Org_MIM, 
				Dt_Prev_Pgto_MIM = @Dt_Prev_Pgto_MIM, 
				Cd_Cred_Dev_MIM = @Cd_Cred_Dev_MIM, 
				Desp_Org_MIM = @Desp_Org_MIM, 
				CPMF_MIM = @CPMF_MIM, 
				Comp_RP_MIM = @Comp_RP_MIM, 
				Comp_DN_MIM = @Comp_DN_MIM,
				Comp_CN_MIM = @Comp_CN_MIM,
				Comp_CPA_MIM = @Comp_CPA_MIM
			Where
				Num_Proc_MIM = @Num_Proc_MIM and 
	 			Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_MIM = @DC_MIM
			If @@RowCount = 1 
				Begin 
					Exec pLogCtaCte_Ins 
						'I' , @Num_Proc_MIM, @Cd_Tp_Tx,@DC_MIM, @Org_Ins_MIM,@Dt_Ins_MIM, @Cd_Tp_Moeda, 
						@Vlr_Org_MIM, @Dt_Prev_Pgto_MIM,@Cd_Cred_Dev_MIM, @Desp_Org_MIM,@CPMF_MIM,@Comp_RP_MIM, 
						@Comp_DN_MIM, @Comp_CN_MIM, @Comp_CPA_MIM, @usuario 
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
					RollBack Transaction
					Return -2 
				End 
					
		End 
	Else
		Begin 
			RollBack Transaction 
			Return - 4
		End
GO
