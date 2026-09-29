SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCteHEM_Ins 
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
@Usuario			Varchar(6), 
@Sys				bit = 0 ,
@IntDefinitiva			int=null
)
--Parâmetros de Retorno 
--(1) Procedimento concluído com exito 
--(-1) Violação de Chave 
--(-2) Erro no Procedimento 
--(-3) Erro na Inserção do Log 
 AS
	Begin Transaction  
	Declare @Cd_Cliente	varchar(10) 
	Declare @Cd_Area	varchar(3) 
	Declare @JOB Varchar(16) 
	Declare @chkjob	char(1) 
	Declare @Comp_Job_HEM	char(1)
	Declare @Grupo	varchar(10)

	Set @Cd_Cliente = IsNull((Select Cd_Export_HEM From House_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM),  '')
	Set @Cd_Area = IsNull((Select Cd_Area From Usuario Where Cd_Usuario = @Usuario),'') 
	Set @JOB = IsNull((Select JOB_HEM From House_Exp_Mar Where Num_Proc_HEM = @Num_Proc_HEM),  '')
	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')	
	Set @Dt_Ins_HEM = (Select DBO.STRHOJE(GETDATE()) AS HOJE)
	If substring(@Num_Proc_HEM, 3,3) = 'JOB'
		Set @Comp_Job_HEM = 'S'
	Else
		Set @Comp_Job_HEM = 'N'


	--If @Cd_Tp_Tx = 'FRT'
	--	Set @CPMF_HEM = 'S'
	If  Not Exists(Select Num_Proc_HEM from Cta_Cte_Hou_Exp_Mar Where  Num_Proc_HEM = @Num_Proc_HEM and Cd_Tp_Tx =@Cd_Tp_Tx and DC_HEM = @DC_HEM) 
		Begin 
			If @Job <> '' and @Num_Proc_HEM <> @JOB and @Sys = 0
				Begin
					If @Cd_Tp_Tx not in (Select Cd_Tp_Tx From tipo_taxa_oper)
						Begin 
							if (@Cd_Area <> 'CSR' and @Grupo <>'ADMIN') and  @Cd_Cred_Dev_HEM = @Cd_Cliente
								Begin 
									Rollback Transaction 
									Return -32
								End 
						End
				End 
			Insert into  
				Cta_Cte_Hou_Exp_Mar
				(Num_Proc_HEM,Cd_Tp_Tx,DC_HEM,Org_Ins_HEM,Dt_Ins_HEM,Cd_Tp_Moeda,Vlr_Org_HEM,Dt_Prev_Pgto_HEM, 
				Cd_Cred_Dev_HEM,Desp_Dst_HEM,CPMF_HEM,Comp_RP_HEM, Comp_DN_HEM, Comp_CN_HEM, Comp_CPA_HEM, 
				Num_DCN_HEM,Dt_Ctb_CC_HEM, Comp_Job_HEM)
			Values 	
				( @Num_Proc_HEM, @Cd_Tp_Tx,@DC_HEM, @Org_Ins_HEM,@Dt_Ins_HEM, @Cd_Tp_Moeda, @Vlr_Org_HEM, 
				@Dt_Prev_Pgto_HEM,@Cd_Cred_Dev_HEM, @Desp_Dst_HEM,@CPMF_HEM,@Comp_RP_HEM, @Comp_DN_HEM, 
				@Comp_CN_HEM, @Comp_CPA_HEM, @Num_DCN_HEM,@Dt_Ctb_CC_HEM, @Comp_Job_HEM)
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins 
						'I', @Num_Proc_HEM, @Cd_Tp_Tx,@DC_HEM, @Org_Ins_HEM,@Dt_Ins_HEM, @Cd_Tp_Moeda, 
						@Vlr_Org_HEM, @Dt_Prev_Pgto_HEM,@Cd_Cred_Dev_HEM, @Desp_Dst_HEM,@CPMF_HEM,@Comp_RP_HEM, 
						@Comp_DN_HEM, @Comp_CN_HEM, @Comp_CPA_HEM, @usuario 
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
			Return - 1 
		End
GO
