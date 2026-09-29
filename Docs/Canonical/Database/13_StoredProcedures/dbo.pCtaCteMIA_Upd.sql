SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE pCtaCteMIA_Upd
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
@Desp_Org_MIA		char(1),
@CPMF_MIA			char(1), 
@Comp_RP_MIA		char(1), 
@Comp_DN_MIA		char(1),
@Comp_CN_MIA		char(1),
@Comp_CPA_MIA		char(1),
@Num_DCN_MIA		varchar(12)=Null, 
@Dt_Ctb_CC_MIA		varchar(10)=Null,
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
	Set @Vlr_Contab = IsNull((Select  Val_Con_Comp From  Cta_Cte_Mas_Imp_Aer Where Num_Proc_MIA = @Num_Proc_MIA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIA = @DC_MIA ) , 0)

	Begin Transaction 
	Set @NF = IsNull((Select  Num_NF_MIA From  Cta_Cte_Mas_Imp_Aer Where Num_Proc_MIA = @Num_Proc_MIA and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_MIA = @DC_MIA ) , '') 
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

	If @DC_MIA = 'D' and @Cd_Tp_Tx in (Select Cd_Tp_Tx From Tipo_Taxa Where Pft_Aer = 'S') and @Grupo <>'ADMIN'
		Begin
			RollBack Transaction 
			Return - 33
		End 

	If (@Vlr_Contab > 0  )
		Begin 
			RollBack Transaction 
			Return -12
		End 
	

	If  Not Exists (Select * From Caixa_Mas_Imp_Aer Where Num_Proc_MIA = @Num_Proc_MIA and Cd_Tp_Tx = @Cd_Tp_Tx and  DC_MIA = @DC_MIA)
		Begin 
			Update 
				Cta_Cte_Mas_Imp_Aer
			Set 
				Cd_Tp_Tx= @Cd_Tp_Tx,
				DC_MIA = @DC_MIA,
				Org_Ins_MIA = @Org_Ins_MIA,
				--Dt_Ins_MIA = @Dt_Ins_MIA,
				Cd_Tp_Moeda = @Cd_Tp_Moeda,
				Vlr_Org_MIA = @Vlr_Org_MIA, 
				Dt_Prev_Pgto_MIA = @Dt_Prev_Pgto_MIA, 
				Cd_Cred_Dev_MIA = @Cd_Cred_Dev_MIA, 
				Desp_Org_MIA = @Desp_Org_MIA, 
				CPMF_MIA = @CPMF_MIA, 
				Comp_RP_MIA = @Comp_RP_MIA, 
				Comp_DN_MIA = @Comp_DN_MIA,
				Comp_CN_MIA = @Comp_CN_MIA,
				Comp_CPA_MIA = @Comp_CPA_MIA
			Where
				Num_Proc_MIA = @Num_Proc_MIA and 
	 			Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_MIA = @DC_MIA
			If @@RowCount = 1 
				Begin 
					Exec pLogCtaCte_Ins 
						'I' , @Num_Proc_MIA, @Cd_Tp_Tx,@DC_MIA, @Org_Ins_MIA,@Dt_Ins_MIA, @Cd_Tp_Moeda, 
						@Vlr_Org_MIA, @Dt_Prev_Pgto_MIA,@Cd_Cred_Dev_MIA, @Desp_Org_MIA,@CPMF_MIA,@Comp_RP_MIA, 
						@Comp_DN_MIA, @Comp_CN_MIA, @Comp_CPA_MIA, @usuario 
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
