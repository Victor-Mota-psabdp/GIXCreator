SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE pCtaCteHEM_Upd
(
@Num_Proc_HEM		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_HEM			char(1),
@Org_Ins_HEM			varchar(9),
@Dt_Ins_HEM			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HEM			float, 
@Dt_Prev_Pgto_HEM		varchar(10), 
@Cd_Cred_Dev_HEM		varchar(10), 
@Desp_Dst_HEM		char(1),
@CPMF_HEM			char(1), 
@Comp_RP_HEM		char(1), 
@Comp_DN_HEM		char(1),
@Comp_CN_HEM		char(1),
@Comp_CPA_HEM		char(1), 
@Num_DCN_HEM		varchar(12)=Null, 
@Dt_Ctb_CC_HEM		varchar(10)=Null,
@Usuario			VarChar(6),
@Sys				bit = 0 ,
@IntDefinitiva			int=null

)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-3) Erro na Inserção do Log 
--(-4) Ja existe baixa - Impossível Altera
 AS
	Begin Transaction  
	Declare @NF VarChar(30) 
	Declare @Dt_Ins DateTime
	Declare @Grupo	VarChar(20) 
	Declare @JOB Varchar(16) 
	Declare @chkjob	char(1) 
	Declare @Cd_Area	varchar(3) 
	Declare @Cd_Cliente 	varchar(10)
	Declare @Vlr_Contab 	Decimal(12,2) 
	Declare @Fatura	Varchar(16)

	Set @JOB = IsNull((Select JOB_HEM From House_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM),  '')
	Set @Cd_Area = IsNull((Select Cd_Area From Usuario Where Cd_Usuario = @Usuario),'') 
	Set @Cd_Cliente = IsNull((Select Cd_Export_HEM From House_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM),  '')
	Set @Grupo = (Select Grupo From Usuario Where Cd_Usuario = @Usuario)
	If @Job <> '' and @Num_Proc_HEM <> @JOB 
		Begin 
			Set @chkjob = (Select Comp_Job_HEM From Cta_Cte_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM and Cd_Tp_Tx = @Cd_Tp_Tx and DC_HEM = @DC_HEM) 
			if @chkjob = 'S' and @Grupo <>'ADMIN'
				Begin 
					Rollback Transaction 
					Return -31 
				End 
			if (@Cd_Area <> 'CSR' and @Grupo <>'ADMIN') and  @Cd_Cred_Dev_HEM = @Cd_Cliente
				Begin 
					If @Cd_Tp_Tx not in (Select Cd_Tp_Tx From tipo_taxa_oper)
						begin 
							Rollback Transaction 
							Return -32
						end
				End 
		End 



	Set @NF = IsNull((Select  Num_NF_HEM From  Cta_Cte_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HEM = @DC_HEM ) , '') 
	If @NF <> ''  and @NF <> '0'
		Begin 
			RollBack Transaction 
			Return -9 

		End

	Set @Dt_Ins = (Select Convert(DateTime, Dt_Ins_HEM, 105) From Cta_Cte_Hou_Exp_Mar  Where Num_Proc_HEM = @Num_Proc_HEM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HEM = @DC_HEM )	
	If (@Dt_Ins <> Dbo.Hoje(GetDate()) and  @Grupo <> 'ADMIN' and Left(@Num_Proc_HEM, 5) <> 'EMJOB' )
		Begin 
			RollBack Transaction 
			Return -10
		End 

	Set @Vlr_Contab = IsNull((Select  Val_Con_Comp From  Cta_Cte_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HEM = @DC_HEM ) , 0) 
	Set @Fatura = IsNull((select top 1 itf.fatcod From item_fat itf join fatura fat on fat.fatcod = itf.fatcod where itf.Num_proc = @Num_Proc_HEM and  Itf.Cd_Tp_Tx =@Cd_Tp_Tx AND DC = @DC_HEM and FatStatus <>0 ), '')

	If (@Fatura <> '' )
		Begin 
			RollBack Transaction 
			Return -11
		End 

	If (@Vlr_Contab > 0  )
		Begin 
			RollBack Transaction 
			Return -12
		End 

	If Not Exists (Select  * From  Caixa_Hou_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM and  Cd_Tp_Tx =@Cd_Tp_Tx AND DC_HEM = @DC_HEM ) 
		Begin 
			Update 
				Cta_Cte_Hou_Exp_Mar
			Set 	
				Num_Proc_HEM = @Num_Proc_HEM,
				Cd_Tp_Tx = @Cd_Tp_Tx,
				DC_HEM=@DC_HEM,
				Org_Ins_HEM = @Org_Ins_HEM,
				--Dt_Ins_HEM=@Dt_Ins_HEM, 
				Cd_Tp_Moeda=@Cd_Tp_Moeda, 
				Vlr_Org_HEM=@Vlr_Org_HEM, 
				Dt_Prev_Pgto_HEM= @Dt_Prev_Pgto_HEM, 
				Cd_Cred_Dev_HEM=@Cd_Cred_Dev_HEM, 
				Desp_Dst_HEM=@Desp_Dst_HEM,
				CPMF_HEM=@CPMF_HEM,	
				Comp_RP_HEM=@Comp_RP_HEM, 
				Comp_DN_HEM=@Comp_DN_HEM, 
				Comp_CN_HEM=@Comp_CN_HEM, 
				Comp_CPA_HEM=@Comp_CPA_HEM, 
				Num_DCN_HEM=@Num_DCN_HEM,
				Dt_Ctb_CC_HEM=@Dt_Ctb_CC_HEM
			Where 
				Num_Proc_HEM = @Num_Proc_HEM and 
				Cd_Tp_Tx = @Cd_Tp_Tx and 
				DC_HEM = @DC_HEM
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins
						'A', @Num_Proc_HEM, @Cd_Tp_Tx,@DC_HEM, @Org_Ins_HEM,@Dt_Ins_HEM, @Cd_Tp_Moeda, 
						@Vlr_Org_HEM, @Dt_Prev_Pgto_HEM,@Cd_Cred_Dev_HEM, @Desp_Dst_HEM,@CPMF_HEM,@Comp_RP_HEM, 
						@Comp_DN_HEM, @Comp_CN_HEM, @Comp_CPA_HEM, @Usuario 
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
					Return - 1 
				End 
		End 
	Else
		Begin 
			Rollback Transaction 
			Return - 4 
		End
GO
