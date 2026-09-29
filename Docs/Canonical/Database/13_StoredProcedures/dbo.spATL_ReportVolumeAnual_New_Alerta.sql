SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_ReportVolumeAnual_New_Alerta]--2014
	@ANO bigint
AS

declare @TAB table
	(
	[Cliente]					varchar(200),
	[Modal]						varchar(100),
    [Localidade]				varchar(100),
	[Janeiro]					int,
	[Fevereiro]					int,
	[Março]						int,
	[Abril]						int,
	[Maio]						int,
	[Junho]						int,
	[Julho]						int,
	[Agosto]					int,
	[Setembro]					int,
	[Outubro]					int,
	[Novembro]					int,
	[Dezembro]					int
	)

	BEGIN
		Insert into 
			@TAB([Cliente],[Modal],[Localidade],[Janeiro],[Fevereiro],[Março],[Abril],[Maio],
			[Junho],[Julho],[Agosto],[Setembro],[Outubro],[Novembro],[Dezembro])	
			select 
				Nome_Cliente				[Cliente],
				Modal						[Modal],
				Localidade					[Localidade],
				Janeiro						[Janeiro],
				Fevereiro					[Fevereiro],
				Marco						[Março],
				Abril						[Abril],
				Maio						[Maio],
				Junho						[Junho],
				Julho						[Julho],
				Agosto						[Agosto],
				Setembro					[Setembro],
				Outubro						[Outubro],
				Novembro					[Novembro],
				Dezembro					[Dezembro]
			 from temp_ReportVolume_Anual_New
			 where ANO = @Ano
			order by (Janeiro+Fevereiro+Marco+Abril+Maio+Junho+Julho+Agosto+Setembro+Outubro+Novembro+Dezembro) desc
	END

	BEGIN
		Insert into 
			@TAB([Cliente],[Modal],[Localidade],[Janeiro],[Fevereiro],[Março],[Abril],[Maio],
			[Junho],[Julho],[Agosto],[Setembro],[Outubro],[Novembro],[Dezembro])
		select 
			'Total'							[Cliente],
			''								[Modal],
			''								[Localidade],
			sum(Janeiro)					[Janeiro],
			sum(Fevereiro)					[Fevereiro],
			sum(Marco)						[Março],
			sum(Abril)						[Abril],
			sum(Maio)						[Maio],
			sum(Junho)						[Junho],
			sum(Julho)						[Julho],
			sum(Agosto)						[Agosto],
			sum(Setembro)					[Setembro],
			sum(Outubro)					[Outubro],
			sum(Novembro)					[Novembro],
			sum(Dezembro)					[Dezembro]
		 from temp_ReportVolume_Anual_New
		 where ANO = @ANO
	END

select * from @TAB




GO
