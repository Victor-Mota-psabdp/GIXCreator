SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spVerificaInformacoesObrigatorias_Sel]--'EAATL201909015BR'
(
	@Num_Proc varchar(16)
)
as

--declare @TAB table
--	(
--		--[BDP Ref.]									 varchar(16),
--		[InformacoesObrigatorias]					 varchar(MAX)		
--	)

--	Begin
--		insert into
--			@TAB ([InformacoesObrigatorias])

	--InformacoesObrigatorias
	--Export Air
	--select * from tipo_campo_cliente where id_campo=178
	select
		(CASE WHEN dbo.fBusca_CampoCliente(MEA.num_proc_mea,178) IS NULL THEN
			'Missing the MAWB Carrier in Additional Fields'
		ELSE '' END) [InformacoesObrigatorias] 
	from 
		Master_Exp_Aer MEA with(nolock)
		Left Join Localidade LCD with(nolock)on MEA.cd_dst_mea = LCD.cd_local
		left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
	Where
		MEA.Num_Proc_mea=@Num_Proc
		--and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')
		and P.HTS = 1
		and MEA.cd_cia_aer in ('AA','BA','LH','AF')
		
	UNION ALL

	select
		(CASE WHEN CMSH.Contato IS NULL THEN
			'Shipper contact is missing from the Company Register'
		ELSE '' END) [InformacoesObrigatorias]	
	from 
		Master_Exp_Aer MEA with(nolock)
		Left Join Pessoa Sh with(nolock)on SH.cd_pes=cd_export_mea
		Left Join Comunicacao CMSH	with(nolock) on CMSH.cd_pes=SH.cd_pes and CMSH.Cd_Tp_Com='TC1'	
		Left Join Localidade LCD with(nolock)on MEA.cd_dst_mea = LCD.cd_local
		left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais

	Where
		MEA.Num_Proc_mea=@Num_Proc
		--and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')
		and P.HTS = 1
		and MEA.cd_cia_aer in ('AA','BA','LH','AF')
		
	UNION ALL
	--select * from tipo_campo_pessoa where id_campo=18
	select
		(CASE WHEN CP.Campo_Dados IS NULL THEN
			'The USCI Code of the Consignee is missing from the Company Register'
		ELSE '' END) [InformacoesObrigatorias]	
	from 
		Master_Exp_Aer MEA with(nolock)
		Left Join Pessoa CS with(nolock)on CS.cd_pes=cd_consig_mea
		Left Join Localidade LCD with(nolock)on MEA.cd_dst_mea = LCD.cd_local
		left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
		left join Campo_Pessoa CP with(nolock)on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '18'	
	Where
		MEA.Num_Proc_mea=@Num_Proc
		--and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')
		and P.HTS = 1
		and MEA.cd_cia_aer in ('AA','BA','LH','AF')
		
--16-10-2024 e 11-11-2024 tratamento 100-472083 - ATL shipments to European Union – Import Control System 2 (ICS2) - House
-- EROI
	UNION ALL
	select
		(CASE WHEN CP.Campo_Dados IS NULL THEN
			'The EORI of the Consignee is missing from the Company Register/Financial'
		ELSE '' END) [InformacoesObrigatorias]	
	from 
		vwHouse_Exp HE with(nolock)
		Left Join Pessoa CS with(nolock)on CS.Cd_Pes=HE.Cd_Consig
		Left Join Localidade LCD with(nolock)on HE.Cd_Dst = LCD.cd_local
        left join Regiao reg with(nolock) on reg.cd_regiao = lcd.cd_regiao 
		left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
		left join Campo_Pessoa CP with(nolock)on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = 28
	Where
		HE.Num_Proc= @Num_Proc
		and reg.LocICS2 = 1
--EROI Master
    Union ALL 		
		select 
		 (CASE WHEN CP.Campo_Dados IS NULL THEN
			'The EORI of the Consignee is missing from the Company Register/Financial'
		ELSE '' END) [InformacoesObrigatorias]	
		from vwMaster_Exp_Completo vm 
		Left Join Pessoa CS with(nolock)on CS.Cd_Pes=vm.Cd_Consig_Master
		Left Join Localidade LCD with(nolock)on LCD.cd_local = vm.Cd_Dst_Master
        left join Regiao reg with(nolock) on reg.cd_regiao = lcd.cd_regiao 
		left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
		left join Campo_Pessoa CP with(nolock)on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = 28
	Where
		vm.Num_Proc_Master = @num_proc
		and reg.LocICS2 = 1	
--NCM
  Union All 
    	select
				(CASE WHEN NCM.ID_NCM_PROC IS NULL THEN
					'The NCM is missing on the JOB/References'
				ELSE '' END) [InformacoesObrigatorias]
			from
				vwHouse_Exp HE with(nolock)
				left JOIN PROC_NCM NCM with(nolock)	ON NCM.Num_Proc = HE.Num_Proc
				Left Outer Join Localidade	LCD with(nolock)	on HE.cd_dst = LCD.cd_local	
				left join Regiao reg with(nolock) on reg.cd_regiao = lcd.cd_regiao 
			where
				HE.num_proc in(@Num_Proc)
			and reg.LocICS2 = 1	
--NCM Master 
  Union All
  	       select
				(CASE WHEN NCM.ID_NCM_PROC IS NULL THEN
					'The NCM is missing on the JOB/References ' 
				ELSE '' END) [InformacoesObrigatorias]
			from
				vwHouse_Exp HE with(nolock)
				left JOIN PROC_NCM NCM with(nolock)	ON NCM.Num_Proc = HE.Num_Proc
				Left Outer Join Localidade	LCD with(nolock)	on HE.cd_dst = LCD.cd_local	
				left join Regiao reg with(nolock) on reg.cd_regiao = lcd.cd_regiao 
			where
				HE.num_proc in(select Num_Proc from vwHouse_Exp HE with(nolock) where HE.Master = @num_proc)
		    and reg.LocICS2 = 1	
		
-----------------------------------------------------------------------------------------------------------------		
		
	UNION ALL
		--Export Maritime
		--select * from tipo_campo_cliente where id_campo=179
			select
				(CASE WHEN dbo.fBusca_CampoCliente(HOU.num_proc_hem,179) IS NULL THEN
					'Need to set the Carrier''s HBL  in Additional Fields'
				ELSE '' END) [InformacoesObrigatorias]			
		from
			house_exp_mar Hou with(nolock)
			Left Outer Join Localidade	LCD with(nolock)on HOU.cd_dst_hem = LCD.cd_local
			left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
		where
			HOU.num_proc_hem = @Num_Proc
			--and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')
			and P.HTS = 1
			
		UNION ALL
		--select * from tipo_campo_cliente where id_campo=180
			select
				(CASE WHEN CP180.Campo_Dados IS NULL THEN
					'EIN Code missing in the Additional Fields'
				ELSE '' END) [InformacoesObrigatorias]	
		from
			house_exp_mar Hou with(nolock)
			Left Outer Join Localidade		LCD with(nolock) on HOU.cd_dst_hem = LCD.cd_local
			left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
			Left outer Join Campo_Processo	CP180 with(nolock)on HOU.Num_Proc_HEM = CP180.Num_Proc and CP180.Id_Campo = 180
		where
			HOU.num_proc_hem = @Num_Proc
			--and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')
			and P.HTS = 1

		UNION ALL
		--select * from tipo_campo_pessoa where id_campo=18
			select
				(CASE WHEN CP.Campo_Dados IS NULL THEN
					'The USCI Code of the Consignee is missing from the Company Register'
				ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			Left Outer Join Pessoa				CS with(nolock)		on CS.cd_pes=cd_consig_hem	
			Left Outer Join Localidade			LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local
			left Join Pais P with(nolock)on P.Cd_Pais = LCD.Cd_Pais
			left join Campo_Pessoa				CP on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '18'
		where
			HOU.num_proc_hem = @Num_Proc
			--and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')
			and P.HTS = 1
			
		--XXXXXXXXXXXXXXXXXX - INDIA REGULATION - XXXXXXXXXXXXXXXXXXXXXXXXX
		--phone number can be made optional, not mandatory for india.
		--	For the consignee and notify address (in case the notify is from India or in case the consignee is " to order" ) :
		--IEC Code - 
		--PAN Code - 
		--E-mail Contact
		--GST Number - 
		--Postal Code(PIN Code) - 
		--In the consignee, if the consignee is froindia, then PAN is required, 
		--in case consignee is not from india then IEC is required.
		--CONSIGNEE
		UNION ALL

		--select * from tipo_campo_pessoa where id_campo = 21
		select
			(CASE WHEN CP.Campo_Dados IS NULL THEN
				--'Falta definir o "IEC Code" do Consignatario no Company Register'
				'The IEC Code of the Consignee is missing on the Company Register'
			ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			JOIN LLP_Exp_Mar			LLP with(nolock) ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
			Left Outer Join Pessoa		CS with(nolock)	on CS.cd_pes=cd_consig_hem	
			Left Outer Join Localidade	LCD with(nolock)on HOU.cd_dst_hem = LCD.cd_local
			Left Outer Join Localidade	LCF with(nolock)on LLP.Cd_DstFinal_Lem = LCF.cd_local
			left join Campo_Pessoa		CP with(nolock) on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '21'
		where
			HOU.num_proc_hem = @Num_Proc
			and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))
			
		UNION ALL

		--select * from tipo_campo_pessoa where id_campo = 20
		select
			(CASE WHEN CP.Campo_Dados IS NULL THEN
				--'Falta definir o "PAN Code" do Consignatario no Company Register'
				'The PAN Code of the Consignee is missing on the Company Register'
			ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			JOIN LLP_Exp_Mar			LLP with(nolock) ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
			Left Outer Join Pessoa		CS with(nolock)		on CS.cd_pes=cd_consig_hem	
			Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local
			Left Outer Join Localidade	LCF with(nolock)on LLP.Cd_DstFinal_Lem = LCF.cd_local
			left join Campo_Pessoa		CP with(nolock) on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '20'
		where
			HOU.num_proc_hem = @Num_Proc
			and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))
			
		UNION ALL

		select
			(CASE WHEN CMC.COMPL_FONE IS NULL THEN
				--'Falta definir o "Email" do Consignatario no Company Register - Tipo: HBL'
				'The Email of the Consignee is missing on the Company Register'
			ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			JOIN LLP_Exp_Mar			LLP with(nolock)	ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
			Left Outer Join Pessoa		CS with(nolock)		on CS.cd_pes=cd_consig_hem	
			Left Outer Join comunicacao	CMC	with(nolock)	on CS.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'
			Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local	
			Left Outer Join Localidade	LCF with(nolock)	on LLP.Cd_DstFinal_Lem = LCF.cd_local
		where
			HOU.num_proc_hem = @Num_Proc
			and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))

		UNION ALL

		--select * from tipo_campo_pessoa where id_campo = 22
		select
			(CASE WHEN CP.Campo_Dados IS NULL THEN
				--'Falta definir o "IEC Code" do Consignatario no Company Register'
				'The GST Number of the Consignee is missing on the Company Register'
				ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			JOIN LLP_Exp_Mar			LLP with(nolock) ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
			Left Outer Join Pessoa		CS with(nolock)		on CS.cd_pes=cd_consig_hem	
			Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local
			Left Outer Join Localidade	LCF with(nolock)on LLP.Cd_DstFinal_Lem = LCF.cd_local
			left join Campo_Pessoa		CP with(nolock) on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '22'
		where
			HOU.num_proc_hem = @Num_Proc
			and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))
			
		UNION ALL

		select
			(CASE WHEN CMC.CEP IS NULL THEN
				--'Falta definir o "Email" do Consignatario no Company Register - Tipo: HBL'
				'The Zip Code of the Consignee is missing on the Company Register/Address'
			ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			JOIN LLP_Exp_Mar			LLP with(nolock)	ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
			Left Outer Join Pessoa		CS with(nolock)		on CS.cd_pes=cd_consig_hem	
			Left Outer Join Endereco	CMC	with(nolock)	on CS.cd_pes = CMC.cd_pes and CMC.Cd_Tp_End = 'COM'
			Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local	
			Left Outer Join Localidade	LCF with(nolock)	on LLP.Cd_DstFinal_Lem = LCF.cd_local
		where
			HOU.num_proc_hem = @Num_Proc
			and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))
			
			
		--------notify when consignee is to order
		--NOTIFY
		UNION ALL

		--select * from tipo_campo_pessoa where id_campo = 21
		select
			(CASE WHEN CP.Campo_Dados IS NULL THEN
				--'Falta definir o "IEC Code" do Consignatario no Company Register'
				'The IEC Code of the Notify is missing on the Company Register/Financial'
			ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			JOIN LLP_Exp_Mar			LLP with(nolock) ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
			Left Outer Join Pessoa		CS with(nolock)	on CS.cd_pes=cd_consig_hem	
			Left Outer Join Pessoa		NF with(nolock)	on NF.cd_pes=HOU.Cd_Notify_HEM	
			Left Outer Join Localidade	LCD with(nolock)on HOU.cd_dst_hem = LCD.cd_local
			Left Outer Join Localidade	LCF with(nolock)on LLP.Cd_DstFinal_Lem = LCF.cd_local
			left join Campo_Pessoa		CP with(nolock) on CP.Cd_Pes = NF.Cd_Pes and cp.Id_Campo = '21'
		where
			HOU.num_proc_hem = @Num_Proc
			and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))
			AND CS.Nome_Raz_Soc LIKE '%order of%'
			
		UNION ALL

		--select * from tipo_campo_pessoa where id_campo = 20
		select
			(CASE WHEN CP.Campo_Dados IS NULL THEN
				--'Falta definir o "PAN Code" do Consignatario no Company Register'
				'The PAN Code of the Notify is missing on the Company Register/Financial'
			ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			JOIN LLP_Exp_Mar			LLP with(nolock) ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
			Left Outer Join Pessoa		CS with(nolock)		on CS.cd_pes=cd_consig_hem	
			Left Outer Join Pessoa		NF with(nolock)	on NF.cd_pes=HOU.Cd_Notify_HEM	
			Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local
			Left Outer Join Localidade	LCF with(nolock)on LLP.Cd_DstFinal_Lem = LCF.cd_local
			left join Campo_Pessoa		CP with(nolock) on CP.Cd_Pes = NF.Cd_Pes and cp.Id_Campo = '20'
		where
			HOU.num_proc_hem = @Num_Proc
			and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))
			AND CS.Nome_Raz_Soc LIKE '%order of%'
			
		UNION ALL

		select
			(CASE WHEN CMC.COMPL_FONE IS NULL THEN
				--'Falta definir o "Email" do Consignatario no Company Register - Tipo: HBL'
				'The Email of the Notify is missing on the Company Register/Contact'
			ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			JOIN LLP_Exp_Mar			LLP with(nolock)	ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
			Left Outer Join Pessoa		CS with(nolock)		on CS.cd_pes=cd_consig_hem
			Left Outer Join Pessoa		NF with(nolock)	on NF.cd_pes=HOU.Cd_Notify_HEM		
			Left Outer Join comunicacao	CMC	with(nolock)	on NF.cd_pes = CMC.cd_pes and CMC.cd_tp_com = 'HBL'
			Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local	
			Left Outer Join Localidade	LCF with(nolock)	on LLP.Cd_DstFinal_Lem = LCF.cd_local
		where
			HOU.num_proc_hem = @Num_Proc
			and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))
			AND CS.Nome_Raz_Soc LIKE '%order of%'

		UNION ALL

		--select * from tipo_campo_pessoa where id_campo = 22
		select
			(CASE WHEN CP.Campo_Dados IS NULL THEN
				--'Falta definir o "IEC Code" do Consignatario no Company Register'
				'The GST Number of the Notify is missing on the Company Register/Financial'
				ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			JOIN LLP_Exp_Mar			LLP with(nolock) ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
			Left Outer Join Pessoa		CS with(nolock)		on CS.cd_pes=cd_consig_hem	
			Left Outer Join Pessoa		NF with(nolock)	on NF.cd_pes=HOU.Cd_Notify_HEM	
			Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local
			Left Outer Join Localidade	LCF with(nolock)on LLP.Cd_DstFinal_Lem = LCF.cd_local
			left join Campo_Pessoa		CP with(nolock) on CP.Cd_Pes = NF.Cd_Pes and cp.Id_Campo = '22'
		where
			HOU.num_proc_hem = @Num_Proc
			and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))
			AND CS.Nome_Raz_Soc LIKE '%order of%'
			
		UNION ALL

		select
			(CASE WHEN CMC.CEP IS NULL THEN
				--'Falta definir o "Email" do Consignatario no Company Register - Tipo: HBL'
				'The Zip Code of the Notify is missing on the Company Register/Address'
			ELSE '' END) [InformacoesObrigatorias]
		from
			house_exp_mar Hou with(nolock)
			JOIN LLP_Exp_Mar			LLP with(nolock)	ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
			Left Outer Join Pessoa		CS with(nolock)		on CS.cd_pes=cd_consig_hem
			Left Outer Join Pessoa		NF with(nolock)	on NF.cd_pes=HOU.Cd_Notify_HEM		
			Left Outer Join Endereco	CMC	with(nolock)	on NF.cd_pes = CMC.cd_pes and CMC.Cd_Tp_End = 'COM'
			Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local	
			Left Outer Join Localidade	LCF with(nolock)	on LLP.Cd_DstFinal_Lem = LCF.cd_local
		where
			HOU.num_proc_hem = @Num_Proc
			and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))
			AND CS.Nome_Raz_Soc LIKE '%order of%'
			

		---- Mandatory in JOB
		--JOB - (Destination Country, Port of Discharge, Place of Delivery or Transshipment in India)
		--Invoice Value
		--Invoice Currency
		--NCM Code
		UNION ALL
		--Invoice Currency
			select
				(CASE WHEN llp.Cd_Moeda_Invoice IS NULL THEN
					--'Falta definir o "Email" do Consignatario no Company Register - Tipo: HBL'
					'The Invoice Currency is missing on the JOB/Ref.Adic/Courier'
				ELSE '' END) [InformacoesObrigatorias]
			from
				house_exp_mar Hou with(nolock)
				JOIN LLP_Exp_Mar			LLP with(nolock)	ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
				Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local	
				Left Outer Join Localidade	LCF with(nolock)	on LLP.Cd_DstFinal_Lem = LCF.cd_local
			where
				HOU.num_proc_hem = @Num_Proc
				and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))

		UNION ALL
		--Invoice Value
			select
				(CASE WHEN llp.Vlr_Invoice IS NULL THEN
					--'Falta definir o "Email" do Consignatario no Company Register - Tipo: HBL'
					'The Invoice Value is missing on the JOB/Ref.Adic/Courier'
				ELSE '' END) [InformacoesObrigatorias]
			from
				house_exp_mar Hou with(nolock)
				JOIN LLP_Exp_Mar			LLP with(nolock)	ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
				Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local	
				Left Outer Join Localidade	LCF with(nolock)	on LLP.Cd_DstFinal_Lem = LCF.cd_local
			where
				HOU.num_proc_hem = @Num_Proc
				and (UPPER(LCD.Cd_Pais) in ('IN') OR UPPER(LCF.Cd_Pais) in ('IN'))
				
		UNION ALL
		--NCM
		--In case port of discharge, place of delivery, country of destination or if there is a transshipment in Morocco  
		--then the HS code needs to be minimum 4 characters. Pls implement this for ocean only.
			select
				(CASE WHEN NCM.ID_NCM_PROC IS NULL THEN
					--'Falta definir o "Email" do Consignatario no Company Register - Tipo: HBL'
					'The NCM is missing on the JOB/References'
				ELSE '' END) [InformacoesObrigatorias]
			from
				house_exp_mar Hou with(nolock)
				JOIN LLP_Exp_Mar LLP with(nolock)	ON LLP.Num_Proc_Lem = HOU.Num_Proc_HEM
				left JOIN PROC_NCM NCM with(nolock)	ON NCM.Num_Proc = HOU.Num_Proc_HEM
				Left Outer Join Localidade	LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local	
				Left Outer Join Localidade	LCF with(nolock)	on LLP.Cd_DstFinal_Lem = LCF.cd_local
			where
				HOU.num_proc_hem = @Num_Proc
				and (UPPER(LCD.Cd_Pais) in ('IN','MA') OR UPPER(LCF.Cd_Pais) in ('IN','MA'))
	
	
	--END
	
	--select * from @TAB where InformacoesObrigatorias <> ''
	
	
	
	/*
	Field - Import to India
	IEC (Importer Exporter Code No) - Consignee
	GSTIN - Consignee/Notify
	Email ID - Consignee/Notify
	City, State, PIN Code (ZIP Code) - Consignee/Notify
	HS Code Number - 6 Digit HS code
	invoice Value - Not to be printed on BL
	*/
		


























	
/*
ALTER procedure [dbo].[spVerificaInformacoesObrigatorias_Sel]
(
	@Num_Proc varchar(16)
)
as

--InformacoesObrigatorias

select
	(CASE WHEN dbo.fBusca_CampoCliente(MEA.num_proc_mea,178) IS NULL THEN
		'Falta definir o Carrier do MAWB nos Campos Adicionais'
	ELSE '' END) [InformacoesObrigatorias] 
from 
	Master_Exp_Aer MEA
	Left Join Localidade LCD with(nolock)on MEA.cd_dst_mea = LCD.cd_local	
Where
	MEA.Num_Proc_mea=@Num_Proc
	and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')
	and MEA.cd_cia_aer in ('AA','BA','LH','AF')
	
UNION ALL

select
	(CASE WHEN CMSH.Contato IS NULL THEN
		'Falta definir o contato do Shipper no Company Register'
	ELSE '' END) [InformacoesObrigatorias]	
from 
	Master_Exp_Aer MEA
	Left Join Pessoa Sh with(nolock)on SH.cd_pes=cd_export_mea
	Left Join Comunicacao CMSH	with(nolock) on CMSH.cd_pes=SH.cd_pes and CMSH.Cd_Tp_Com='TC1'	
	Left Join Localidade LCD with(nolock)on MEA.cd_dst_mea = LCD.cd_local

Where
	MEA.Num_Proc_mea=@Num_Proc
	and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')
	and MEA.cd_cia_aer in ('AA','BA','LH','AF')
	
UNION ALL

select
	(CASE WHEN CP.Campo_Dados IS NULL THEN
		'Falta definir o USCI Code do Consignatario no Company Register'
	ELSE '' END) [InformacoesObrigatorias]	
from 
	Master_Exp_Aer MEA
	Left Join Pessoa CS with(nolock)on CS.cd_pes=cd_consig_mea
	Left Join Localidade LCD with(nolock)on MEA.cd_dst_mea = LCD.cd_local
	left join Campo_Pessoa CP with(nolock)on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '18'	
Where
	MEA.Num_Proc_mea=@Num_Proc
	and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')
	and MEA.cd_cia_aer in ('AA','BA','LH','AF')

	
UNION ALL

	select
		(CASE WHEN dbo.fBusca_CampoCliente(HOU.num_proc_hem,179) IS NULL THEN
			'Falta definir o Armador do HBL nos Campos Adicionais'
		ELSE '' END) [InformacoesObrigatorias]			
from
	house_exp_mar Hou with(nolock)
	Left Outer Join Localidade	LCD with(nolock)on HOU.cd_dst_hem = LCD.cd_local
where
	HOU.num_proc_hem = @Num_Proc
	and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')
	
UNION ALL

	select
		(CASE WHEN CP180.Campo_Dados IS NULL THEN
			'Falta definir o codigo EIN Code nos Campos Adicionais'
		ELSE '' END) [InformacoesObrigatorias]	
from
	house_exp_mar Hou with(nolock)
	Left Outer Join Localidade		LCD with(nolock) on HOU.cd_dst_hem = LCD.cd_local
	Left outer Join Campo_Processo	CP180 with(nolock)on HOU.Num_Proc_HEM = CP180.Num_Proc and CP180.Id_Campo = 180
where
	HOU.num_proc_hem = @Num_Proc
	and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')

UNION ALL

	select
		(CASE WHEN CP.Campo_Dados IS NULL THEN
			'Falta definir o codigo USCI Code do Consignatario no Company Register'
		ELSE '' END) [InformacoesObrigatorias]
from
	house_exp_mar Hou with(nolock)
	Left Outer Join Pessoa				CS with(nolock)		on CS.cd_pes=cd_consig_hem	
	Left Outer Join Localidade			LCD with(nolock)	on HOU.cd_dst_hem = LCD.cd_local
	left join Campo_Pessoa				CP on CP.Cd_Pes = CS.Cd_Pes and cp.Id_Campo = '18'
where
	HOU.num_proc_hem = @Num_Proc
	and UPPER(LCD.Cd_Pais) in ('CN','ID','MY')

*/

GO
