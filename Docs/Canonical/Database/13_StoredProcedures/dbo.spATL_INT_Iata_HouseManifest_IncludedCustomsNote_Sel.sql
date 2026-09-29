SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_INT_Iata_HouseManifest_IncludedCustomsNote_Sel]--'','IncludedCustomsNote'
(		
	@Num_Proc 	VarChar(16),
	@Tipo		varchar(200)
)	
AS


IF	not exists(select Num_Proc from ATL_INT.dbo.Iata_HouseManifest_IncludedCustomsNote where Num_Proc = @Num_Proc and Type = @Tipo)
	BEGIN	
		if @Tipo = 'IncludedHouseConsignmentIncludedCustomsNote'
			--select 	'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'AGT'SubjectCode,'T'ContentCode,'Informar "CNPJ<número do CNPJ com 8 dígitos'	Content	
			select 	'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'AGT'SubjectCode,'T'ContentCode,'' Content, 1 OrderBY, NULL ID_HouseManifest
			union all
			select 	'IncludedHouseConsignmentIncludedCustomsNote'Type,'BR'CountryID,'WBI'SubjectCode,''ContentCode,'CARRIERDECLARATIONDATEAAAAMMDD'	Content	,2 OrderBY	, NULL ID_HouseManifest
			Order by OrderBY 
		else
			select 	'IncludedCustomsNote'Type,'BR'CountryID,'WBI'SubjectCode,'DI'ContentCode,'NON-IATA'Content	, 1 OrderBY	, NULL ID_HouseManifest
			union all
			select 	'IncludedCustomsNote'Type,'BR'CountryID,'WBI'SubjectCode,''ContentCode,'CARRIERDECLARATIONDATEAAAAMMDD'Content,2 OrderBY, NULL ID_HouseManifest
			Order by OrderBY 
	END
ELSE
	BEGIN
		select 
			Type,
			CountryID,
			SubjectCode,
			ContentCode,
			Content,OrderBY,
			ID_HouseManifest
		from 
			ATL_INT.dbo.Iata_HouseManifest_IncludedCustomsNote HOU with(nolock)	
		Where
			hou.Num_Proc=@Num_Proc
			and Type = @Tipo
			and CountryID is not null
		Order by OrderBY 

	END

GO
