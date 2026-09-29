SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_help Booking_Request_Container
--[spATL_Booking_Request_Container_Sel]	'EMCSR202002005BR','35051','A'
--select * from Pedido_ship PS
--	join Produto_Perigoso p on p.cd_prod = PS.cd_produto
--where num_proc  like 'EMOXT201802021BR%'
--select * from Produto_Cliente where cd_prod = '42990'
--Declare	@Num_Proc			VarChar(16)
--Declare	@Cd_Proc_Cliente	VarChar(30)

--Set @Num_Proc= 'EMOXT201802021BR'
--set @Cd_Proc_Cliente  = '71847'
CREATE PROCEDURE [dbo].[spATL_Booking_Request_Container_Sel]	
(
	@Num_Proc			VarChar(16),
	@Item_Cont			int,
	@Tipo				char(1)
)
AS

if @tipo = 'A' or @Tipo = 'B'
	BEGIN
		Select 
			convert(varchar(25),'Saved')	[Status],
			BR.Num_Proc						[JOB],
			BR.Item_Cont					[Item],
			BR.Qty							[Qty],
			BR.Cd_Tp_Cont					[Container Type Code],
			BR.Name_Tp_Cont					[Container Type Name],
			BR.Container_Comments			[Container Comments],
			BR.Cd_Pes_Haulage				[Haulage Code],
			BR.Name_Pes_Haulage				[Haulage Name],
			BR.Dt_Requested_Empty_PickUp	[Requested Empty PickUp Date],
			BR.Contact_Name					[Contact Name],
			BR.Contact_Number				[Contact Number],
			BR.Temperature					[Temperature],
			BR.Degree						[Degree],
			BR.Humidity						[Humidity],
			BR.Vent_Status					[Vent Status],
			BR.Length						[Length],
			BR.Width						[Width],
			BR.Height						[Height],
			BR.UoM							[UoM],
			TC.Cd_Smart						[Container Type Smart Code]
		From 
			Booking_Request_Container BR with(nolock)
			left join Tipo_Container TC with(nolock) on TC.cd_tp_cont = BR.Cd_Tp_Cont
		Where
			BR.Num_proc = @Num_Proc
	END

if @tipo = 'C' or @Tipo = 'D'
	BEGIN
		Select 
			convert(varchar(25),'Saved')	[Status],
			BR.Num_Proc						[JOB],
			BR.Item_Cont					[Item],
			BR.Qty							[Qty],
			BR.Cd_Tp_Cont					[Container Type Code],
			BR.Name_Tp_Cont					[Container Type Name],
			BR.Container_Comments			[Container Comments],
			BR.Cd_Pes_Haulage				[Haulage Code],
			BR.Name_Pes_Haulage				[Haulage Name],
			BR.Dt_Requested_Empty_PickUp	[Requested Empty PickUp Date],
			BR.Contact_Name					[Contact Name],
			BR.Contact_Number				[Contact Number],
			BR.Temperature					[Temperature],
			BR.Degree						[Degree],
			BR.Humidity						[Humidity],
			BR.Vent_Status					[Vent Status],
			BR.Length						[Length],
			BR.Width						[Width],
			BR.Height						[Height],
			BR.UoM							[UoM],
			TC.Cd_Smart						[Container Type Smart Code]
		From 
			Booking_Request_Container BR with(nolock)
			left join Tipo_Container TC with(nolock) on TC.cd_tp_cont = BR.Cd_Tp_Cont			
		Where
			BR.Num_proc = @Num_Proc and BR.Item_Cont=@Item_Cont
	END


GO
