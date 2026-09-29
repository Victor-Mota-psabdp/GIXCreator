SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spGIX2ATL_ReferenciasDiversas_InsUPD] 
	@Num_Proc		varchar(16),
	@Tipo			varchar(30),
	@Dado			varchar(100)
AS

BEGIN TRANSACTION

--Navio_HIM

If @Tipo='Freight Currency'
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set Cd_Tp_Moeda=@Dado Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set Cd_Tp_Moeda=@Dado  Where Num_Proc_HIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update House_Imp_Out Set Cd_Tp_Moeda=@Dado Where Num_Proc_HIO=@Num_Proc
					End
			End
	End
	
ELSE If @Tipo='Freight Value'
	Begin
		set @dado = replace(@Dado, '.','')
		set @dado = replace(@Dado, ',','.')
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set Vlr_Frete_Efet_HIA=cast(@Dado as float) Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set Vlr_Frete_Efet_HIM=cast(@Dado as float) Where Num_Proc_HIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update House_Imp_Out Set Vlr_Frete_Efet_HIO=cast(@Dado as float) Where Num_Proc_HIO=@Num_Proc
					End
			End
	End	
	
Else If @Tipo='Volume(M3)'
	Begin
		set @dado = replace(@Dado, '.','')
		set @dado = replace(@Dado, ',','.')
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set Vol_Tot_HIA=cast(@Dado as float) Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set Vol_Tot_HIM=cast(@Dado as float) Where Num_Proc_HIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update House_Imp_Out Set Vol_Tot_HIO=cast(@Dado as float) Where Num_Proc_HIO=@Num_Proc
					End
			End
	End
	
Else If @Tipo='Net Weight(KG)'
	Begin
		set @dado = replace(@Dado, '.','')
		set @dado = replace(@Dado, ',','.')
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set Peso_Real_HIA=cast(@Dado as float) Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set Peso_Liquido_HIM=cast(@Dado as float) Where Num_Proc_HIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update House_Imp_Out Set Peso_Real_HIO=cast(@Dado as float) Where Num_Proc_HIO=@Num_Proc
					End
			End
	End
	
Else If @Tipo='Gross Weight(KG)'
	Begin
		set @dado = replace(@Dado, '.','')
		set @dado = replace(@Dado, ',','.')
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set Peso_Bruto_HIA=cast(@Dado as float) Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set Peso_Bruto_HIM=cast(@Dado as float) Where Num_Proc_HIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update House_Imp_Out Set Peso_Bruto_HIO=cast(@Dado as float) Where Num_Proc_HIO=@Num_Proc
					End
			End
	End
	
--NOVO PARA A PIBERNAT
--Else If @Tipo='Terminal'
--	Begin		
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
--					Begin
--						Update LLP_Imp_Aer Set Cd_Terminal=@Dado Where Num_Proc_Lia=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
--					Begin
--						Update LLP_Imp_Mar Set Cd_Terminal=@Dado  Where Num_Proc_LIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
--					Begin
--						Update LLP_Imp_Out Set Cd_Terminal=@Dado Where Num_Proc_LIO=@Num_Proc
--					End
--			End
--	End

Else If @Tipo='Invoice Currency'
	Begin		
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set Cd_Moeda_Invoice=@Dado Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set Cd_Moeda_Invoice=@Dado  Where Num_Proc_LIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set Cd_Moeda_Invoice=@Dado Where Num_Proc_LIO=@Num_Proc
					End
			End
	End
	
Else If @Tipo='Invoice Value'
	Begin
		--set @dado = replace(@Dado, '.','')
		set @dado = replace(@Dado, ',','.')		
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_LIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set Vlr_Invoice =cast(@Dado as float) Where Num_Proc_LIO=@Num_Proc
					End
			End
	End
	
Else If @Tipo='Incoterm'
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set Cd_Tp_Oper=@Dado Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set Cd_Tp_Oper=@Dado  Where Num_Proc_HIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update House_Imp_Out Set Cd_Tp_Oper=@Dado Where Num_Proc_HIO=@Num_Proc
					End
			End
	End
	
--NOVO PARA A PIBERNAT
--Else If @Tipo='MAWB'
--	Begin
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update House_Imp_Aer Set MAWB_HIA=@Dado Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set MAWB_HIM=@Dado  Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update House_Imp_Out Set MAWB_HIO=@Dado Where Num_Proc_HIO=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='HAWB'
--	Begin
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update House_Imp_Aer Set HAWB_HIA=@Dado Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set HAWB_HIM=@Dado  Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update House_Imp_Out Set HAWB_HIO=@Dado Where Num_Proc_HIO=@Num_Proc
--					End
--			End
--	End	
	
Else If @Tipo='ETA'	
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set ETA_LIA=cast(@Dado as Date) Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set ETA_Lim=cast(@Dado as Date)  Where Num_Proc_Lim=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set ETA_Lio=cast(@Dado as Date) Where Num_Proc_Lio=@Num_Proc
					End
			End
	End
	
Else If @Tipo='ATA'	
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set ATA_LIA=cast(@Dado as DateTime) Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set ATA_Lim=cast(@Dado as DateTime)  Where Num_Proc_Lim=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set ATA_Lio=cast(@Dado as DateTime) Where Num_Proc_Lio=@Num_Proc
					End
			End
	End
	
Else If @Tipo='ETD'	
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set ETD_LIA=cast(@Dado as Date) Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set ETD_Lim=cast(@Dado as Date)  Where Num_Proc_Lim=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set ETD_Lio=cast(@Dado as Date) Where Num_Proc_Lio=@Num_Proc
					End
			End
	End
	
Else If @Tipo='ATD'	
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set ATD_LIA=cast(@Dado as DateTime) Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set ATD_lim=cast(@Dado as DateTime)  Where Num_Proc_Lim=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set ATD_Lio=cast(@Dado as DateTime) Where Num_Proc_Lio=@Num_Proc
					End
			End
	End
	
Else If @Tipo='Navio' or @Tipo = 'Vessel'
	Begin
		--If Left(@Num_Proc,2)='IA'
		--	Begin
		--		If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
		--			Begin
		--				Update House_Imp_Aer Set Voo_HIA=@Dado Where Num_Proc_HIA=@Num_Proc
		--			End
		--	End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set Navio_HIM=@Dado  Where Num_Proc_HIM=@Num_Proc
					End
			End
		--If Left(@Num_Proc,2)='IO'
		--	Begin
		--		If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
		--			Begin
		--				Update House_Imp_Out Set Voo_HIO=@Dado Where Num_Proc_HIO=@Num_Proc
		--			End
		--	End
	End
	
Else If @Tipo='Agent'
	Begin		
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
					Begin
						Update Job_Imp_Aer Set Cd_Agente=@Dado Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
					Begin
						Update Job_Imp_mar Set Cd_Agente=@Dado Where Num_Proc_HIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set Cd_Agente=@Dado Where Num_Proc_LIO=@Num_Proc
					End
			End
	End

---xxxxxxxxxxxxxxPibernat
Else If @Tipo='Channel'
	Begin 
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set Canal_LIA=@Dado Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set Canal_Lim=@Dado  Where Num_Proc_LIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set Canal_Lio=@Dado Where Num_Proc_LIO=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_Lea from LLP_Exp_Aer where Num_Proc_Lea=@Num_Proc)
					Begin
						Update LLP_exp_Aer Set Canal_Lea=@Dado Where Num_Proc_Lea=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_Lem from LLP_Exp_Mar where Num_Proc_Lem=@Num_Proc)
					Begin
						Update LLP_exp_Mar Set Canal_Lem=@Dado  Where Num_Proc_Lem=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_Leo from LLP_Exp_Out where Num_Proc_Leo=@Num_Proc)
					Begin
						Update LLP_exp_Out Set Canal_Leo =@Dado Where Num_Proc_Leo=@Num_Proc
					End
			End
	End
	
Else If @Tipo='Terminal'
	Begin 
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set Cd_Terminal=@Dado Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set Cd_Terminal=@Dado  Where Num_Proc_LIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set Cd_Terminal=@Dado Where Num_Proc_LIO=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_LEA from LLP_Exp_Aer where Num_Proc_LEA=@Num_Proc)
					Begin
						Update LLP_Exp_Aer Set Cd_Terminal=@Dado Where Num_Proc_LEA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_LEM from LLP_Exp_Mar where Num_Proc_LEM=@Num_Proc)
					Begin
						Update LLP_Exp_Mar Set Cd_Terminal=@Dado  Where Num_Proc_LEM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_LEO from LLP_Exp_Out where Num_Proc_LEO=@Num_Proc)
					Begin
						Update LLP_Exp_Out Set Cd_Terminal=@Dado Where Num_Proc_LEO=@Num_Proc
					End
			End
	End

Else If @Tipo='Inland Trucker'
	Begin 
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set Cd_Transportadora=@Dado Where Num_Proc_Lia=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set Cd_Transportadora=@Dado  Where Num_Proc_LIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
					Begin
						Update LLP_Imp_Out Set Cd_Transportadora=@Dado Where Num_Proc_LIO=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_LEA from LLP_Exp_Aer where Num_Proc_LEA=@Num_Proc)
					Begin
						Update LLP_Exp_Aer Set Cd_Transportadora=@Dado Where Num_Proc_LEA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_LEM from LLP_Exp_Mar where Num_Proc_LEM=@Num_Proc)
					Begin
						Update LLP_Exp_Mar Set Cd_Transportadora=@Dado  Where Num_Proc_LEM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_LEO from LLP_Exp_Out where Num_Proc_LEO=@Num_Proc)
					Begin
						Update LLP_Exp_Out Set Cd_Transportadora=@Dado Where Num_Proc_LEO=@Num_Proc
					End
			End
	End	
	
Else If @Tipo='MAWB'
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set MAWB_HIA=@Dado Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set MAWB_HIM=@Dado  Where Num_Proc_HIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update House_Imp_Out Set MAWB_HIO=@Dado Where Num_Proc_HIO=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_HEA from House_Exp_Aer where Num_Proc_HEA=@Num_Proc)
					Begin
						Update House_Exp_Aer Set MAWB_HEA=@Dado Where Num_Proc_HEA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_HEM from House_Exp_Mar where Num_Proc_HEM=@Num_Proc)
					Begin
						Update House_Exp_Mar Set MAWB_HEM=@Dado  Where Num_Proc_HEM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_HEO from House_Exp_Out where Num_Proc_HEO=@Num_Proc)
					Begin
						Update House_Exp_Out Set MAWB_HEO=@Dado Where Num_Proc_HEO=@Num_Proc
					End
			End
	End	
	
Else If @Tipo='HAWB'
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set HAWB_HIA=@Dado Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set HAWB_HIM=@Dado  Where Num_Proc_HIM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IO'
			Begin
				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
					Begin
						Update House_Imp_Out Set HAWB_HIO=@Dado Where Num_Proc_HIO=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EA'
			Begin
				If exists(select Num_Proc_HEA from House_Exp_Aer where Num_Proc_HEA=@Num_Proc)
					Begin
						Update House_Exp_Aer Set HAWB_HEA=@Dado Where Num_Proc_HEA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EM'
			Begin
				If exists(select Num_Proc_HEM from House_Exp_Mar where Num_Proc_HEM=@Num_Proc)
					Begin
						Update House_Exp_Mar Set HAWB_HEM=@Dado  Where Num_Proc_HEM=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='EO'
			Begin
				If exists(select Num_Proc_HEO from House_Exp_Out where Num_Proc_HEO=@Num_Proc)
					Begin
						Update House_Exp_Out Set HAWB_HEO=@Dado Where Num_Proc_HEO=@Num_Proc
					End
			End
	End	
	
---xxxxxxxxxxxxxxIntegraGIX2ATL
--select * from ATL_INT.dbo.Tipo_Campo_House_Temp
--Voyage
Else If @Tipo='Voyage'
	Begin
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set Voo_HIA=@Dado Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set Viagem_HIM =@Dado  Where Num_Proc_HIM=@Num_Proc
					End
			End
		--If Left(@Num_Proc,2)='IO'
		--	Begin
		--		If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
		--			Begin
		--				Update House_Imp_Out Set Voo_HIO=@Dado Where Num_Proc_HIO=@Num_Proc
		--			End
		--	End
	End
	
--Nº of Pieces
Else If @Tipo='Nº of Pieces'
	Begin
		set @dado = replace(@Dado, '.','')
		set @dado = replace(@Dado, ',','.')
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
					Begin
						Update House_Imp_Aer Set Qtd_Tot_Vol_HIA=cast(@Dado as float) Where Num_Proc_HIA=@Num_Proc
					End
			End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
					Begin
						Update House_Imp_Mar Set Qtd_Tot_Vol_HIM=cast(@Dado as float) Where Num_Proc_HIM=@Num_Proc
					End
			End
		--If Left(@Num_Proc,2)='IO'
		--	Begin
		--		If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
		--			Begin
		--				Update House_Imp_Out Set Vol_Tot_HIO=cast(@Dado as float) Where Num_Proc_HIO=@Num_Proc
		--			End
		--	End
	End
	
--Charg. Weight (KG)
Else If @Tipo='Net Weight(KG)'
	Begin
		set @dado = replace(@Dado, '.','')
		set @dado = replace(@Dado, ',','.')
		If Left(@Num_Proc,2)='IA'
			Begin
				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
					Begin
						Update LLP_Imp_Aer Set Peso_Cubado_LIA=cast(@Dado as float) Where Num_Proc_Lia=@Num_Proc
					End
			End		
	End
	
--Booking Number
Else If @Tipo='Booking Number'
	Begin 
		--If Left(@Num_Proc,2)='IA'
		--	Begin
		--		If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
		--			Begin
		--				Update LLP_Imp_Aer Set Nr_Reserva=@Dado Where Num_Proc_Lia=@Num_Proc

		--			End
		--	End
		If Left(@Num_Proc,2)='IM'
			Begin
				If exists(select Num_Proc_Lim from LLP_Imp_Mar where Num_Proc_Lim=@Num_Proc)
					Begin
						Update LLP_Imp_Mar Set Nr_Reserva=@Dado  Where Num_Proc_Lim=@Num_Proc
					End
			End
		--If Left(@Num_Proc,2)='IO'
		--	Begin
		--		If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
		--			Begin
		--				Update LLP_Imp_Out Set Nr_Reserva=@Dado Where Num_Proc_LIO=@Num_Proc
		--			End
		--	End
	End
	

	IF @@ERROR<>0 
		BEGIN
			ROLLBACK TRANSACTION
			RETURN -1
		END

COMMIT TRANSACTION













--ALTER Procedure [dbo].[spGIX2ATL_ReferenciasDiversas_InsUPD] 
--	@Num_Proc		varchar(16),
--	@Tipo			varchar(30),
--	@Dado			varchar(100)
--AS

--BEGIN TRANSACTION

----Navio_HIM

--If @Tipo='Freight Currency'
--	Begin
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update House_Imp_Aer Set Cd_Tp_Moeda=@Dado Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set Cd_Tp_Moeda=@Dado  Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update House_Imp_Out Set Cd_Tp_Moeda=@Dado Where Num_Proc_HIO=@Num_Proc
--					End
--			End
--	End
	
--ELSE If @Tipo='Freight Value'
--	Begin
--		set @dado = replace(@Dado, '.','')
--		set @dado = replace(@Dado, ',','.')
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update House_Imp_Aer Set Vlr_Frete_Efet_HIA=cast(@Dado as float) Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set Vlr_Frete_Efet_HIM=cast(@Dado as float) Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update House_Imp_Out Set Vlr_Frete_Efet_HIO=cast(@Dado as float) Where Num_Proc_HIO=@Num_Proc
--					End
--			End
--	End	
	
--Else If @Tipo='Volume(M3)'
--	Begin
--		set @dado = replace(@Dado, '.','')
--		set @dado = replace(@Dado, ',','.')
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update House_Imp_Aer Set Vol_Tot_HIA=cast(@Dado as float) Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set Vol_Tot_HIM=cast(@Dado as float) Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update House_Imp_Out Set Vol_Tot_HIO=cast(@Dado as float) Where Num_Proc_HIO=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='Net Weight(KG)'
--	Begin
--		set @dado = replace(@Dado, '.','')
--		set @dado = replace(@Dado, ',','.')
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update House_Imp_Aer Set Peso_Real_HIA=cast(@Dado as float) Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set Peso_Liquido_HIM=cast(@Dado as float) Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update House_Imp_Out Set Peso_Real_HIO=cast(@Dado as float) Where Num_Proc_HIO=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='Gross Weight(KG)'
--	Begin
--		set @dado = replace(@Dado, '.','')
--		set @dado = replace(@Dado, ',','.')
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update House_Imp_Aer Set Peso_Bruto_HIA=cast(@Dado as float) Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set Peso_Bruto_HIM=cast(@Dado as float) Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update House_Imp_Out Set Peso_Bruto_HIO=cast(@Dado as float) Where Num_Proc_HIO=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='Terminal'
--	Begin		
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
--					Begin
--						Update LLP_Imp_Aer Set Cd_Terminal=@Dado Where Num_Proc_Lia=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
--					Begin
--						Update LLP_Imp_Mar Set Cd_Terminal=@Dado  Where Num_Proc_LIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
--					Begin
--						Update LLP_Imp_Out Set Cd_Terminal=@Dado Where Num_Proc_LIO=@Num_Proc
--					End
--			End
--	End

--Else If @Tipo='Invoice Currency'
--	Begin		
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
--					Begin
--						Update LLP_Imp_Aer Set Cd_Moeda_Invoice=@Dado Where Num_Proc_Lia=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
--					Begin
--						Update LLP_Imp_Mar Set Cd_Moeda_Invoice=@Dado  Where Num_Proc_LIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
--					Begin
--						Update LLP_Imp_Out Set Cd_Moeda_Invoice=@Dado Where Num_Proc_LIO=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='Invoice Value'
--	Begin
--		--set @dado = replace(@Dado, '.','')
--		set @dado = replace(@Dado, ',','.')		
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
--					Begin
--						Update LLP_Imp_Aer Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_Lia=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
--					Begin
--						Update LLP_Imp_Mar Set Vlr_Invoice=cast(@Dado as float) Where Num_Proc_LIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
--					Begin
--						Update LLP_Imp_Out Set Vlr_Invoice =cast(@Dado as float) Where Num_Proc_LIO=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='Incoterm'
--	Begin
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update House_Imp_Aer Set Cd_Tp_Oper=@Dado Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set Cd_Tp_Oper=@Dado  Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update House_Imp_Out Set Cd_Tp_Oper=@Dado Where Num_Proc_HIO=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='MAWB'
--	Begin
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update House_Imp_Aer Set MAWB_HIA=@Dado Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set MAWB_HIM=@Dado  Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update House_Imp_Out Set MAWB_HIO=@Dado Where Num_Proc_HIO=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='HAWB'
--	Begin
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update House_Imp_Aer Set HAWB_HIA=@Dado Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set HAWB_HIM=@Dado  Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update House_Imp_Out Set HAWB_HIO=@Dado Where Num_Proc_HIO=@Num_Proc
--					End
--			End
--	End	
	
--Else If @Tipo='ETA'	
--	Begin
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update LLP_Imp_Aer Set ETA_LIA=cast(@Dado as Date) Where Num_Proc_Lia=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update LLP_Imp_Mar Set ETA_Lim=cast(@Dado as Date)  Where Num_Proc_Lim=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update LLP_Imp_Out Set ETA_Lio=cast(@Dado as Date) Where Num_Proc_Lio=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='ATA'	
--	Begin
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update LLP_Imp_Aer Set ATA_LIA=cast(@Dado as DateTime) Where Num_Proc_Lia=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update LLP_Imp_Mar Set ATA_Lim=cast(@Dado as DateTime)  Where Num_Proc_Lim=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update LLP_Imp_Out Set ATA_Lio=cast(@Dado as DateTime) Where Num_Proc_Lio=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='ETD'	
--	Begin
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update LLP_Imp_Aer Set ETD_LIA=cast(@Dado as Date) Where Num_Proc_Lia=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update LLP_Imp_Mar Set ETD_Lim=cast(@Dado as Date)  Where Num_Proc_Lim=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update LLP_Imp_Out Set ETD_Lio=cast(@Dado as Date) Where Num_Proc_Lio=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='ATD'	
--	Begin
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--					Begin
--						Update LLP_Imp_Aer Set ATD_LIA=cast(@Dado as DateTime) Where Num_Proc_Lia=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update LLP_Imp_Mar Set ATD_lim=cast(@Dado as DateTime)  Where Num_Proc_Lim=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--					Begin
--						Update LLP_Imp_Out Set ATD_Lio=cast(@Dado as DateTime) Where Num_Proc_Lio=@Num_Proc
--					End
--			End
--	End
	
--Else If @Tipo='Navio'
--	Begin
--		--If Left(@Num_Proc,2)='IA'
--		--	Begin
--		--		If exists(select Num_Proc_HIA from House_Imp_Aer where Num_Proc_HIA=@Num_Proc)
--		--			Begin
--		--				Update House_Imp_Aer Set Voo_HIA=@Dado Where Num_Proc_HIA=@Num_Proc
--		--			End
--		--	End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_HIM from House_Imp_Mar where Num_Proc_HIM=@Num_Proc)
--					Begin
--						Update House_Imp_Mar Set Navio_HIM=@Dado  Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		--If Left(@Num_Proc,2)='IO'
--		--	Begin
--		--		If exists(select Num_Proc_HIO from House_Imp_Out where Num_Proc_HIO=@Num_Proc)
--		--			Begin
--		--				Update House_Imp_Out Set Voo_HIO=@Dado Where Num_Proc_HIO=@Num_Proc
--		--			End
--		--	End
--	End
	
--Else If @Tipo='Agent'
--	Begin		
--		If Left(@Num_Proc,2)='IA'
--			Begin
--				If exists(select Num_Proc_Lia from LLP_Imp_Aer where Num_Proc_Lia=@Num_Proc)
--					Begin
--						Update Job_Imp_Aer Set Cd_Agente=@Dado Where Num_Proc_HIA=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IM'
--			Begin
--				If exists(select Num_Proc_LIM from LLP_Imp_Mar where Num_Proc_LIM=@Num_Proc)
--					Begin
--						Update Job_Imp_mar Set Cd_Agente=@Dado Where Num_Proc_HIM=@Num_Proc
--					End
--			End
--		If Left(@Num_Proc,2)='IO'
--			Begin
--				If exists(select Num_Proc_LIO from LLP_Imp_Out where Num_Proc_LIO=@Num_Proc)
--					Begin
--						Update LLP_Imp_Out Set Cd_Agente=@Dado Where Num_Proc_LIO=@Num_Proc
--					End
--			End
--	End


--	IF @@ERROR<>0 
--		BEGIN
--			ROLLBACK TRANSACTION
--			RETURN -1
--		END

--COMMIT TRANSACTION












GO
