SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE pCtaCteHIA_Ins 
(
@Num_Proc_HIA		varchar(16), 
@Cd_Tp_Tx			varchar(3),
@DC_HIA			char(1),
@Org_Ins_HIA			varchar(9),
@Dt_Ins_HIA			varchar(10), 
@Cd_Tp_Moeda		varchar(3), 
@Vlr_Org_HIA			float, 
@Dt_Prev_Pgto_HIA		varchar(10)='', 
@Cd_Cred_Dev_HIA		varchar(10), 
@Desp_Org_HIA		char(1)='N',
@CPMF_HIA			char(1)='N', 
@Comp_RP_HIA		char(1)='N', 
@Comp_DN_HIA		char(1)='N',
@Comp_CN_HIA		char(1)='N',
@Comp_CPA_HIA		char(1)='N', 
@Num_DCN_HIA		varchar(12)=Null, 
@Dt_Ctb_CC_HIA		varchar(10)=Null,
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
	Declare @Cd_Cliente	varchar(10) 
	Declare @Cd_Area	varchar(3) 
	Declare @JOB Varchar(16) 
	Declare @chkjob	char(1) 
	Declare @Comp_Job_HIA	char(1)
	Declare @Grupo	varchar(10)

	Begin Transaction  
	Set @Dt_Ins_HIA = (Select DBO.STRHOJE(GETDATE()) AS HOJE)
	Set @Grupo = IsNull((Select Grupo From Usuario Where Cd_Usuario = @Usuario),'')
	If  Not Exists(Select Num_Proc_HIA from Cta_Cte_Hou_Imp_Aer Where  Num_Proc_HIA = @Num_Proc_HIA and Cd_Tp_Tx =@Cd_Tp_Tx and DC_HIA = @DC_HIA) 
		Begin 
			Set @Cd_Cliente = IsNull((Select Cd_Import_HIA From House_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA),  '')
			Set @Cd_Area = IsNull((Select Cd_Area From Usuario Where Cd_Usuario = @Usuario),'') 
			Set @JOB = IsNull((Select JOB_HIA From House_Imp_Aer Where Num_Proc_HIA = @Num_Proc_HIA),  '')

			If substring(@Num_Proc_HIA, 3,3) = 'JOB'
				Set @Comp_Job_HIA = 'S'
			Else
				Set @Comp_Job_HIA = 'N'

			If @Job <> '' and @Num_Proc_HIA <> @JOB and @Sys = 0
				Begin
					If @Cd_Tp_Tx not in (Select Cd_Tp_Tx From tipo_taxa_oper)
						begin 
							if (@Cd_Area <> 'CSR' and @Grupo <>'ADMIN') and  @Cd_Cred_Dev_HIA = @Cd_Cliente
								Begin 
									Rollback Transaction 
									Return -32
								End 
						end
				End 

			If @DC_HIA = 'D' and @Cd_Tp_Tx in (Select Cd_Tp_Tx From Tipo_Taxa Where Pft_Aer = 'S') and @Grupo <>'ADMIN'
				Begin
					RollBack Transaction 
					Return - 33
				End 

			Insert into  
				Cta_Cte_Hou_Imp_Aer
				(Num_Proc_HIA,Cd_Tp_Tx,DC_HIA,Org_Ins_HIA,Dt_Ins_HIA,Cd_Tp_Moeda,Vlr_Org_HIA,Dt_Prev_Pgto_HIA, 
				Cd_Cred_Dev_HIA,Desp_Org_HIA,CPMF_HIA,Comp_RP_HIA, Comp_DN_HIA, Comp_CN_HIA, Comp_CPA_HIA, 
				Num_DCN_HIA,Dt_Ctb_CC_HIA)
			Values 	
				( @Num_Proc_HIA, @Cd_Tp_Tx,@DC_HIA, @Org_Ins_HIA,@Dt_Ins_HIA, @Cd_Tp_Moeda, @Vlr_Org_HIA, 
				@Dt_Prev_Pgto_HIA,@Cd_Cred_Dev_HIA, @Desp_Org_HIA,@CPMF_HIA,@Comp_RP_HIA, @Comp_DN_HIA, 
				@Comp_CN_HIA, @Comp_CPA_HIA, @Num_DCN_HIA,@Dt_Ctb_CC_HIA)
			If @@RowCount  = 1  	
				Begin 
					Exec pLogCtaCte_Ins 
						'I', @Num_Proc_HIA, @Cd_Tp_Tx,@DC_HIA, @Org_Ins_HIA,@Dt_Ins_HIA, @Cd_Tp_Moeda, 
						@Vlr_Org_HIA, @Dt_Prev_Pgto_HIA,@Cd_Cred_Dev_HIA, @Desp_Org_HIA,@CPMF_HIA,@Comp_RP_HIA, 
						@Comp_DN_HIA, @Comp_CN_HIA, @Comp_CPA_HIA, @usuario 
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
