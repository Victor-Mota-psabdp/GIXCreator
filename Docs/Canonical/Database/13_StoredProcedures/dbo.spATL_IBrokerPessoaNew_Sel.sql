SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE procedure [dbo].[spATL_IBrokerPessoaNew_Sel](
 @Num_Proc varchar(16),
 @Tipo varchar(1)
)
---Tipo = C ---Consignne
---Tipo = S ---Seller
---Tipo = B ---Buyer

as


Declare @CodigoIB varchar(4)
Declare @Apelido varchar(50)
Declare @Detalhe varchar(max)
--set @Num_Proc = 'IMGVD201503058BR'



Declare @Cd_Pes varchar(50)

if @Tipo = 'B'
begin
	select @Cd_Pes = C.Cd_Pes, @Apelido =C.Apelido,@CodigoIB = right(Isnull(BU.Campo_Dados,'0'),4) from Pedido_Ship PS
	join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	left join Campo_Pessoa BU on PD.Cd_Buyer = BU.Cd_Pes and BU.Id_Campo = 14
	join Pessoa C on PD.Cd_Buyer = C.Cd_Pes
	where Num_Proc = @Num_Proc
end

if @Tipo = 'S'
begin

	select @Cd_Pes = C.Cd_Pes, @Apelido =C.Apelido,@CodigoIB = right(isnull(SL.Campo_Dados,'0'),4) from Pedido_Ship PS
	join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	join Pessoa C on PD.Cd_Seller = C.Cd_Pes
	left join Campo_Pessoa SL on PD.Cd_Seller = SL.Cd_Pes and SL.Id_Campo = 15
	where Num_Proc = @Num_Proc
end

if @Tipo = 'C'
begin
	select @Cd_Pes = C.Cd_Pes, @Apelido =C.Apelido, @CodigoIB = right(isnull(CS.Campo_Dados,'0'),4) from Pedido_Ship PS
	join Pedido PD on PS.cd_pedido = PD.Cd_pedido
	left join Campo_Pessoa CS on PD.Cd_Consignee = CS.Cd_Pes and CS.Id_Campo = 14
	join Pessoa C on PD.Cd_Consignee = C.Cd_Pes
	where Num_Proc = @Num_Proc
end

Declare @TempTable Table (
	Detalhe varchar(max)
)

insert @TempTable
exec [spATL_PessoaEndCdPes_Sel] @Cd_Pes,'C'

Select @Cd_Pes Cd_Pes,@CodigoIB Ibroker, @Apelido Apelido,(select Detalhe from @TempTable) as Detalhe

--select * from dbo.IBROKER_ITEA
--where [02] = 'IMGVD201503058B'

--select * from dbo.IBROKER_ITEA
--where replace([23],' ','') <> ''
-- dbo.IBROKER_CAP1 set [07]='0070' , [08]='0070'
--where [02] = 'IMGVD201503058B'

          
GO
