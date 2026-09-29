SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE	Procedure [dbo].[spReferenciasDiversas_InsUPD] 
	@Num_Proc		varchar(16),
	@Tipo			varchar(30),
	@Dado			varchar(100)
AS

BEGIN TRANSACTION

If @Tipo='BANK'
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_LIA=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set Banco=@Dado Where Num_Proc_LIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_Lim from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set Banco=@Dado Where Num_Proc_LIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set Banco=@Dado Where Num_Proc_LIO=@Num_Proc
					End
			End
	End
	
Else If @Tipo='INVOICE CURRENCY'
	Begin
		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_LEA from LLP_Exp_Aer where Num_Proc_LEA=@Num_Proc)
					Begin
						Update LLP_Exp_Aer Set Cd_Moeda_Invoice=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Dado) Where Num_Proc_LEA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_LEM from LLP_Exp_Mar where Num_Proc_LEM=@Num_Proc)
					Begin
						Update LLP_Exp_Mar Set Cd_Moeda_Invoice=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Dado) Where Num_Proc_LEM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_LEO from LLP_Exp_Out where Num_Proc_LEO=@Num_Proc)
					Begin
						Update LLP_Exp_Out Set Cd_Moeda_Invoice=(select cd_tp_moeda from tipo_moeda where nome_tp_moeda=@Dado) Where Num_Proc_LEO=@Num_Proc
					End
			End
	End

Else If @Tipo='INVOICE VALUE'
	Begin
		set @dado = replace(@Dado, '.','')
		set @dado = replace(@Dado, ',','.')
		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_LEA from LLP_Exp_Aer where Num_Proc_LEA=@Num_Proc)
					Begin
						Update LLP_Exp_Aer Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_LEA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_LEM from LLP_Exp_Mar where Num_Proc_LEM=@Num_Proc)
					Begin
						Update LLP_Exp_Mar Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_LEM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_LEO from LLP_Exp_Out where Num_Proc_LEO=@Num_Proc)
					Begin
						Update LLP_Exp_Out Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_LEO=@Num_Proc
					End
			End
	End

Else If @Tipo='BOOKING NUMBER'
	Begin
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set Nr_Reserva=@Dado Where Num_Proc_LIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_HEM from JOB_Exp_Mar where Num_Proc_HEM=@Num_Proc)
					Begin
						Update JOB_Exp_Mar Set Nr_Reserva=@Dado Where Num_Proc_HEM=@Num_Proc
					End
			End
	End

Else If @Tipo='INTL. REFERENCE'
	Begin
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set Intl_Ref_LIO=@Dado Where Num_Proc_LIO=@Num_Proc
					End
			End
	End

Else If @Tipo='INCOTERM'
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set cd_tp_oper=(Select cd_tp_oper from tipo_oper where Nome_tp_oper = @Dado) 
						Where Num_Proc_HIA=@Num_Proc
					End
			End

		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set cd_tp_oper=(Select cd_tp_oper from tipo_oper where Nome_tp_oper = @Dado) 
						Where Num_Proc_HIM=@Num_Proc
					End
			End

		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update House_Imp_Out Set cd_tp_oper=(Select cd_tp_oper from tipo_oper where Nome_tp_oper = @Dado) 
						Where Num_Proc_HIO=@Num_Proc
					End
			End

		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_HEA from House_Exp_Aer where Num_Proc_HEA=@Num_Proc)
					Begin
						Update House_Exp_Aer Set cd_tp_oper=(Select cd_tp_oper from tipo_oper where Nome_tp_oper = @Dado) 
						Where Num_Proc_HEA=@Num_Proc
					End
			End

		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_HEM from House_Exp_Mar where Num_Proc_HEM=@Num_Proc)
					Begin
						Update House_Exp_Mar Set cd_tp_oper=(Select cd_tp_oper from tipo_oper where Nome_tp_oper = @Dado) 
						Where Num_Proc_HEM=@Num_Proc
					End
			End

		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_HEO from House_Exp_Out where Num_Proc_HEO=@Num_Proc)
					Begin
						Update House_Exp_Out Set cd_tp_oper=(Select cd_tp_oper from tipo_oper where Nome_tp_oper = @Dado) 
						Where Num_Proc_HEO=@Num_Proc
					End
			End

	End

Else If @Tipo='CUSTOMER'
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from JOB_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update JOB_Imp_Aer Set cd_usuario=(Select top 1 cd_usuario from usuario where Nome_Usuario = @Dado) 
						Where Num_Proc_HIA=@Num_Proc
					End
			End

		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from JOB_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update JOB_Imp_Mar Set cd_usuario=(Select top 1 cd_usuario from usuario where Nome_Usuario = @Dado)
						Where Num_Proc_HIM=@Num_Proc
					End
			End

		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_LIO from LLP_IMP_OUT where Num_Proc_LIO=@Num_Proc)
					Begin
						Update LLP_IMP_OUT Set cd_usuario=(Select top 1 cd_usuario from usuario where Nome_Usuario = @Dado) 
						Where Num_Proc_LIO=@Num_Proc
					End
			End

		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_HEA from JOB_Exp_Aer where Num_Proc_HEA=@Num_Proc)
					Begin
						Update JOB_Exp_Aer Set cd_usuario=(Select top 1 cd_usuario from usuario where Nome_Usuario = @Dado)
						Where Num_Proc_HEA=@Num_Proc
					End
			End

		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_HEM from JOB_Exp_Mar where Num_Proc_HEM=@Num_Proc)
					Begin
						Update JOB_Exp_Mar Set cd_usuario=(Select top 1 cd_usuario from usuario where Nome_Usuario = @Dado)
						Where Num_Proc_HEM=@Num_Proc
					End
			End

		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_LEO from LLP_EXP_OUT where Num_Proc_LEO=@Num_Proc)
					Begin
						Update LLP_EXP_OUT Set cd_usuario=(Select top 1 cd_usuario from usuario where Nome_Usuario = @Dado) 
						Where Num_Proc_LEO=@Num_Proc
					End
			End

	End


--TICKET: 100-98271	
Else If @Tipo='Cd_Moeda_Invoice'
	Begin
		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_LEA from LLP_Exp_Aer where Num_Proc_LEA=@Num_Proc)
					Begin
						Update LLP_Exp_Aer Set Cd_Moeda_Invoice=@Dado Where Num_Proc_LEA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_LEM from LLP_Exp_Mar where Num_Proc_LEM=@Num_Proc)
					Begin
						Update LLP_Exp_Mar Set Cd_Moeda_Invoice=@Dado Where Num_Proc_LEM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_LEO from LLP_Exp_Out where Num_Proc_LEO=@Num_Proc)
					Begin
						Update LLP_Exp_Out Set Cd_Moeda_Invoice=@Dado Where Num_Proc_LEO=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set Cd_Moeda_Invoice=@Dado Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_Lim from LLP_Imp_Mar where Num_Proc_Lim=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set Cd_Moeda_Invoice=@Dado Where Num_Proc_Lim=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_Lio from LLP_Imp_Out where Num_Proc_Lio=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set Cd_Moeda_Invoice=@Dado Where Num_Proc_Lio=@Num_Proc
					End
			End
	End

-- NAO LEMBRO ONDE QUE USO ISSO :(	 CADU
Else If @Tipo='Vlr_Invoice'
	Begin
		set @dado = replace(@Dado, '.','')
		set @dado = replace(@Dado, ',','.')
		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_LEA from LLP_Exp_Aer where Num_Proc_LEA=@Num_Proc)
					Begin
						Update LLP_Exp_Aer Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_LEA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_LEM from LLP_Exp_Mar where Num_Proc_LEM=@Num_Proc)
					Begin
						Update LLP_Exp_Mar Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_LEM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_LEO from LLP_Exp_Out where Num_Proc_LEO=@Num_Proc)
					Begin
						Update LLP_Exp_Out Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_LEO=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_Lia from LLP_IMP_Aer where Num_Proc_Lia=@Num_Proc)
					Begin
						Update LLP_IMP_Aer Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_Lim from LLP_IMP_Mar where Num_Proc_Lim=@Num_Proc)
					Begin
						Update LLP_IMP_Mar Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_Lim=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_Lio from LLP_IMP_Out where Num_Proc_Lio=@Num_Proc)
					Begin
						Update LLP_IMP_Out Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_Lio=@Num_Proc
					End
			End
	End

-- usado para integração com o excel - 100-111091
Else If UPPER(@Tipo)='TERMINAL'
	BEGIN
		Declare @Cd_Terminal varchar(10)
		Set @cd_Terminal =(Select cd_terminal from Terminal with(nolock) where Nome_Terminal = @Dado)
			IF @cd_Terminal IS NOT NULL
				Begin
					If Left(@Num_Proc,2)='IA'
						Begin
							If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
								Begin
									Update LLP_Imp_Aer Set Cd_Terminal=@cd_Terminal	Where Num_Proc_Lia=@Num_Proc
								End
						End

					If Left(@Num_Proc,2)='IM'
						Begin
							If exists(select Num_Proc_Lim from LLP_Imp_Mar where Num_Proc_Lim=@Num_Proc)
								Begin
									Update LLP_Imp_Mar Set Cd_Terminal=@cd_Terminal
									Where Num_Proc_Lim=@Num_Proc
								End
						End

					If Left(@Num_Proc,2)='IO'
						Begin
							If exists(select Num_Proc_Lio from LLP_Imp_Out where Num_Proc_Lio=@Num_Proc)
								Begin
									Update LLP_Imp_Out Set Cd_Terminal=@cd_Terminal
									Where Num_Proc_Lio=@Num_Proc
								End
						End

					If Left(@Num_Proc,2)='EA'
						Begin
							If exists(select Num_Proc_Lea from LLP_Exp_Aer where Num_Proc_Lea=@Num_Proc)
								Begin
									Update LLP_Exp_Aer Set Cd_Terminal=@cd_Terminal
									Where Num_Proc_Lea=@Num_Proc
								End
						End

					If Left(@Num_Proc,2)='EM'
						Begin
							If exists(select Num_Proc_Lem from LLP_Exp_Mar where Num_Proc_Lem=@Num_Proc)
								Begin
									Update LLP_Exp_Mar Set Cd_Terminal=@cd_Terminal
									Where Num_Proc_Lem=@Num_Proc
								End
						End

					If Left(@Num_Proc,2)='EO'
						Begin
							If exists(select Num_Proc_Leo from LLP_Exp_Out where Num_Proc_Leo=@Num_Proc)
								Begin
									Update LLP_Exp_Out Set Cd_Terminal=@cd_Terminal
									Where Num_Proc_Leo=@Num_Proc
								End
						End
				End
	END
	
Else If UPPER(@Tipo)='INLAND TRUCKER'
	BEGIN
		Declare	@Cd_Transportadora	Varchar(10)
		Set @Cd_Transportadora =(Select Cd_pes from Pessoa with(nolock) where Apelido = @Dado)
		IF @Cd_Transportadora IS NOT NULL
			Begin
				If Left(@Num_Proc,2)='IA'
					Begin
						If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
							Begin
								Update LLP_Imp_Aer Set Cd_Transportadora = @Cd_Transportadora
								Where Num_Proc_Lia=@Num_Proc
							End
					End

				If Left(@Num_Proc,2)='IM'
					Begin
						If exists(select Num_Proc_Lim from LLP_Imp_Mar where Num_Proc_Lim=@Num_Proc)
							Begin
								Update LLP_Imp_Mar Set Cd_Transportadora = @Cd_Transportadora
								Where Num_Proc_Lim=@Num_Proc
							End
					End

				If Left(@Num_Proc,2)='IO'
					Begin
						If exists(select Num_Proc_Lio from LLP_Imp_Out where Num_Proc_Lio=@Num_Proc)
							Begin
								Update LLP_Imp_Out Set Cd_Transportadora = @Cd_Transportadora
								Where Num_Proc_Lio=@Num_Proc
							End
					End

				If Left(@Num_Proc,2)='EA'
					Begin
						If exists(select Num_Proc_Lea from LLP_Exp_Aer where Num_Proc_Lea=@Num_Proc)
							Begin
								Update LLP_Exp_Aer Set Cd_Transportadora= @Cd_Transportadora
								Where Num_Proc_Lea=@Num_Proc
							End
					End

				If Left(@Num_Proc,2)='EM'
					Begin
						If exists(select Num_Proc_Lem from LLP_Exp_Mar where Num_Proc_Lem=@Num_Proc)
							Begin
								Update LLP_Exp_Mar Set Cd_Transportadora= @Cd_Transportadora
								Where Num_Proc_Lem=@Num_Proc
							End
					End

				If Left(@Num_Proc,2)='EO'
					Begin
						If exists(select Num_Proc_Leo from LLP_Exp_Out where Num_Proc_Leo=@Num_Proc)
							Begin
								Update LLP_Exp_Out Set Cd_Transportadora= @Cd_Transportadora
								Where Num_Proc_Leo=@Num_Proc
							End
					End

			End	
	END	
	
	
	

	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION












GO
