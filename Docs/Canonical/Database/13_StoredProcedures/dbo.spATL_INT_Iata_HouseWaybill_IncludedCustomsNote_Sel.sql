SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spATL_INT_Iata_HouseWaybill_IncludedCustomsNote_Sel]'IASOL202111001BR','IncludedCustomsNote'

CREATE Procedure [dbo].[spATL_INT_Iata_HouseWaybill_IncludedCustomsNote_Sel]
(		
	@Num_Proc 	VarChar(16),
	@Tipo		VarChar(200)
)	
AS

IF	not exists(select top 1 Num_Proc from ATL_INT.dbo.Iata_HouseWaybill_IncludedCustomsNote where Num_Proc = @Num_Proc and Type = @Tipo)
	BEGIN	
		
			--select 	'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'OCI'SubjectCode,'DI'ContentCode,'WOOD PARTS'	Content	
			select 	'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'OCI'SubjectCode,'DI'ContentCode,''	Content	

			union all

			select 	
				'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'CNE'SubjectCode,'T'ContentCode,
				--'Se for um CPF informar "CPF<número do CPF com 11 dígitos>" . Ex: CPF12345678901|
				--Se for um CNPJ informar "CNPJ<número do CNPJ com 8 ou 14 dígitos>". Ex:CNPJ12345678901234|
				--Se for um Passaporte informar "PASSPORT<número do passaporte com até 25 posições>. Ex:PASSPORTC12345678'	Content
				(case when len(P.Num_CPF_CNPJ) = 11 then 'CPF'+ P.Num_CPF_CNPJ else
				'CNPJ' + Num_CPF_CNPJ end) Content
			from House_Imp_Aer HOU with (nolock)
				join Pessoa P with (nolock) on P.cd_pes = HOU.cd_consig_hia
			where 
				HOU.Num_proc_hia = @Num_Proc

			union all

			select 	
				--'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'IMP'SubjectCode,'U'ContentCode,
				'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'IMP'SubjectCode,''ContentCode,
				--'Informar UCR<número da RUC com até 32 posições>. Ex: UCR8BR167017161001713D0000000000004021'Content
				[dbo].[fBusca_Docs_PO_Modal] ( @Num_Proc,205) Content
			
			union all
			
			select 
				'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'CCL'SubjectCode,'M'ContentCode,
				--Informar "CUSTOMSWAREHOUSE<número do Código do Recinto Aduaneiro de Destino da Carga com 7 dígitos>". Ex:CUSTOMSWAREHOUSE1234567
				(case when LCO.Cd_Recinto is null then '' else
				'CUSTOMSWAREHOUSE' + LCO.Cd_Recinto end) Content
			--from LLP_Imp_Aer HOU with (nolock)
			--	left join Terminal P with (nolock) on P.cd_terminal = HOU.cd_terminal
			from House_Imp_Aer HOU with (nolock)
				left Join Recinto_Aduaneiro LCO with(nolock) on HOU.cd_dst_HIA = LCO.Cd_Local				
			where 
				HOU.Num_proc_hia = @Num_Proc

			--select 
			--	'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'CCL'SubjectCode,'M'ContentCode,
			--	--Informar "CUSTOMSWAREHOUSE<número do Código do Recinto Aduaneiro de Destino da Carga com 7 dígitos>". Ex:CUSTOMSWAREHOUSE1234567
			--	(case when P.cd_repart is null then '' else
			--	'CUSTOMSWAREHOUSE' + P.cd_repart end) Content
			----from LLP_Imp_Aer HOU with (nolock)
			----	left join Terminal P with (nolock) on P.cd_terminal = HOU.cd_terminal
			--from House_Imp_Aer HOU with (nolock)
			--	Join Localidade LCO with(nolock) on HOU.cd_dst_HIA = LCO.cd_local
			--	left join Terminal P with (nolock) on HOU.cd_dst_HIA = P.cd_Term_Ofc
			--where 
			--	HOU.Num_proc_hia = @Num_Proc

			--select 	'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'CCL'SubjectCode,'M'ContentCode,
			--'Informar "CUSTOMSWAREHOUSE<número do Código do Recinto Aduaneiro de Destino da Carga com 7 dígitos>". Ex:CUSTOMSWAREHOUSE1234567'Content
	END
ELSE
	BEGIN
		select 
			Type,
			CountryID,
			SubjectCode,
			ContentCode,
			Content
		from 
			ATL_INT.dbo.Iata_HouseWaybill_IncludedCustomsNote HOU with(nolock)	
		Where
			hou.Num_Proc=@Num_Proc
			and Type = @Tipo

	END

GO
