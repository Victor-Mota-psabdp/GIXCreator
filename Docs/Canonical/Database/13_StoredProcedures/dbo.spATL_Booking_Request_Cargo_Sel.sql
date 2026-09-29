SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--[spATL_Booking_Request_Cargo_Sel]	'EMARC202110001BR',null,'S'
CREATE PROCEDURE [dbo].[spATL_Booking_Request_Cargo_Sel]	
(
	@Num_Proc			VarChar(16),
	--@Cd_Proc_Cliente	VarChar(30),
	@NCM				varchar(20),
	@Tipo				char(1)
)
AS

if @tipo = 'A' or @Tipo = 'B'
	BEGIN
		Select 
			convert(varchar(25),'Saved')	[Status],
			BR.Num_Proc					[JOB],
			BR.Cd_Prod					[Code],
			BR.Cd_Proc_Cliente			[Product Code],
			BR.Produto_Description		[Product Description],
			BR.NCM						[NCM],
			BR.Net_Weight				[Net Weight],
			BR.Gross_Weight				[Gross Weight],
			BR.Qtde_Embal				[Qty Packet],
			BR.Cd_Tp_Embal				[Type Packet Code],
			BR.Name_Tp_Embal			[Type Packet Name],		
			BR.UN_Number				[UN Code],
			BR.IMO_Class				[IMO Class],
			BR.Proper_Shipping_Name		[Shipper Proper Name],
			BR.fsPoint					[FlashPoint],
			BR.Temperature				[Temperature],
			BR.Packing_Group			[Packing Group],
			BR.Emergency_Contact_Name	[Emergency Contact Name],
			BR.Emergency_Contact_Number	[Emergency Contact Number],					
		
			JOB.Cd_Pes_grupo 			[Group Code],
			P.Apelido					[Group Name],
			TE.ISO_CODE					[ISO_CODE]
		From Booking_Request_Cargo		BR	with(nolock)	
			left join Booking_Request	JOB with(nolock) on BR.Num_Proc = JOB.num_proc
			left join Pessoa			P	with(nolock) on P.Cd_Pes = JOB.Cd_Pes_grupo	
				left join Tipo_Embalagem	TE		with(nolock) on TE.Cd_Tp_Embal = BR.Cd_Tp_Embal
		Where
			BR.Num_proc = @Num_Proc	

	END

if @tipo = 'C' or @Tipo = 'D'
	BEGIN
		Select 
			convert(varchar(25),'Saved')	[Status],
			BR.Num_Proc					[JOB],
			BR.Cd_Prod					[Code],
			BR.Cd_Proc_Cliente			[Product Code],
			BR.Produto_Description		[Product Description],
			BR.NCM						[NCM],
			BR.Net_Weight				[Net Weight],
			BR.Gross_Weight				[Gross Weight],
			BR.Qtde_Embal				[Qty Packet],
			BR.Cd_Tp_Embal				[Type Packet Code],
			BR.Name_Tp_Embal			[Type Packet Name],	
		
			BR.UN_Number				[UN Code],
			BR.IMO_Class				[IMO Class],
			BR.Proper_Shipping_Name		[Shipper Proper Name],
			BR.fsPoint					[FlashPoint],
			BR.Temperature				[Temperature],
			BR.Packing_Group			[Packing Group],
			BR.Emergency_Contact_Name	[Emergency Contact Name],
			BR.Emergency_Contact_Number	[Emergency Contact Number],
					
			JOB.Cd_Pes_grupo 			[Group Code],
			P.Apelido					[Group Name],
			TE.ISO_CODE					[ISO_CODE]
		From Booking_Request_Cargo		BR	with(nolock)	
			left join Booking_Request	JOB with(nolock) on BR.Num_Proc = JOB.num_proc
			left join Pessoa			P	with(nolock) on P.Cd_Pes = JOB.Cd_Pes_grupo	
			left join Tipo_Embalagem	TE		with(nolock) on TE.Cd_Tp_Embal = BR.Cd_Tp_Embal
		Where
			BR.Num_proc = @Num_Proc and BR.NCM = @NCM --BR.Cd_Proc_Cliente=@Cd_Proc_Cliente

	END

if @tipo = 'S' or @Tipo = 'O'
	BEGIN
		Select 
			convert(varchar(25),'New')	[Status],
			PS.Num_Proc					[JOB],
			PS.cd_produto				[Code],
			PC.cd_Proc_Cliente			[Product Code],
			PC.Produto_Descr			[Product Description],
			PD.NCM						[NCM],
			sum(PD.Peso_Liquido_TOT)	[Net Weight],
			sum(PD.Peso_Bruto_TOT)		[Gross Weight],
			sum(PD.Qtde_Embal)			[Qty Packet],
			PD.Cd_Tp_Embal				[Type Packet Code],
			TE.Nome_Tp_Embal			[Type Packet Name],	
		
			PP.uncode					[UN Code],
			PP.classCode				[IMO Class],
			PP.HazMat_Name_Material		[Shipper Proper Name],
			PP.FlashPoint				[FlashPoint],
			PP.measureCode				[Temperature],
			PP.packingCode				[Packing Group],
			PP.HazMat_Contact			[Emergency Contact Name],
			PP.HazMat_Phone				[Emergency Contact Number],
					
			P.Cd_Pes_grupo 				[Group Code],
			PG.Apelido					[Group Name],
			TE.ISO_CODE					[ISO_CODE]		
		From Pedido_Ship PS
			join Pedido_Det PD with(nolock) on PS.cd_pedido=PD.Cd_Pedido and PS.cd_produto=PD.Cd_Produto and
				ps.Item = PD.Item AND PS.Lote = PD.Lote			
			left join vwClienteALLJOBs		JOB		with(nolock) on PS.Num_Proc = JOB.num_proc
			left join Pessoa_LLP			P		with(nolock) on P.Cd_Pes = JOB.cd_cliente
			left join Pessoa				PG		with(nolock) on PG.Cd_Pes = JOB.cd_cliente
			join Produto_Cliente			PC		with(nolock) on PC.cd_prod = PS.cd_produto and PC.cd_Cliente = P.Cd_Pes_Grupo	
			left join Produto_Perigoso		PP		with(nolock) on PC.cd_prod = PP.cd_prod
			left join Tipo_Embalagem		TE		with(nolock) on TE.Cd_Tp_Embal = PD.Cd_Tp_Embal			
		Where
			PS.Num_proc = @Num_Proc
		Group By
			PS.Num_Proc,PS.cd_produto,PC.cd_Proc_Cliente,PC.Produto_Descr,PD.NCM,	PD.Cd_Tp_Embal,
			TE.Nome_Tp_Embal,PP.uncode,PP.classCode,PP.HazMat_Name_Material,PP.FlashPoint,
			PP.measureCode,PP.packingCode,PP.HazMat_Contact,PP.HazMat_Phone,P.Cd_Pes_grupo,PG.Apelido
			,TE.ISO_CODE
	END

GO
