SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from Container_Temp_Imp_Mar
--[spContainer_Temp_Imp_Mar_Sel]42,'D'
CREATE Procedure [dbo].[spContainer_Temp_Imp_Mar_Sel]--'2'
(
	@ID			BIGINT,
	@Tipo		char(1)
)

as

if @Tipo = 'A'  or @Tipo = 'B' 
	Begin
		select 
			convert(varchar(25),'Saved')			[Status],
			HOU.ID								[ID],
			HOU.ID_Req							[ID Req],
			HOU.Intl_Reference					[Intl Reference],
			--HOU.ID_House_Temp,
			HOU.Num_Proc						[JOB],
			HOU.Item_Cont_IM					[Item],
			HOU.Num_Cont_IM						[Reference],	
			HOU.Cd_Tp_Cont						[Container Type Code],
			TC.Nome_Tp_Cont						[Container Type],
			HOU.Name_Type_Container				[Container Type XML],			
			HOU.Num_Lacre_IM					[Seal],
			HOU.Lacre_02_IM						[Seal 2],
			HOU.Lacre_03_IM						[Seal 3],
			--HOU.Lacre_04_IM						[Seal 4],
			replace(HOU.Peso_Bruto_IM,'.',',')					[Gross Weight],
			replace(HOU.VolumeM3,'.',',')					[VolumeM3],
			HOU.Dt_Vcto_Devol_IM				[Exp. Del. Date],
			HOU.Dt_Devol_IM						[Return Date],
			--HOU.ID_ISO							[ID_ISO],
			--HOU.Tara_IM							[Tara_IM],
			--HOU.DataDevCli_IM					[DataDevCli_IM],
			--HOU.inspecao						[Inspecao],
			HOU.Dt_Ins							[Insert Date]
		from Container_Temp_Imp_Mar HOU with(nolock)
		left join Tipo_Container TC	with(nolock) on TC.Cd_Tp_Cont  = HOU.Cd_Tp_Cont	
	End
	
if @Tipo = 'C'  or @Tipo = 'D'
	Begin
		select 
			convert(varchar(25),'Saved')			[Status],	
			HOU.ID								[ID],
			HOU.ID_Req							[ID Req],
			HOU.Intl_Reference					[Intl Reference],
			--HOU.ID_House_Temp,
			HOU.Num_Proc						[JOB],
			HOU.Item_Cont_IM					[Item],
			HOU.Num_Cont_IM						[Reference],	
			HOU.Cd_Tp_Cont						[Container Type Code],
			TC.Nome_Tp_Cont						[Container Type],
			HOU.Name_Type_Container				[Container Type XML],			
			HOU.Num_Lacre_IM					[Seal],
			HOU.Lacre_02_IM						[Seal 2],
			HOU.Lacre_03_IM						[Seal 3],
			--HOU.Lacre_04_IM						[Seal 4],
		replace(HOU.Peso_Bruto_IM,'.',',')					[Gross Weight],
			replace(HOU.VolumeM3,'.',',')					[VolumeM3],
			HOU.Dt_Vcto_Devol_IM				[Exp. Del. Date],
			HOU.Dt_Devol_IM						[Return Date],
			--HOU.ID_ISO							[ID_ISO],
			--HOU.Tara_IM							[Tara_IM],
			--HOU.DataDevCli_IM					[DataDevCli_IM],
			--HOU.inspecao						[Inspecao],
			HOU.Dt_Ins							[Insert Date]
		from Container_Temp_Imp_Mar HOU with(nolock)
		left join Tipo_Container TC	with(nolock) on TC.Cd_Tp_Cont  = HOU.Cd_Tp_Cont	
		where
			HOU.ID = @ID
	End

GO
