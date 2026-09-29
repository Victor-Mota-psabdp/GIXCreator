SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from invoice_cliente where num_proc = 'EOAXT201404001BR'
--select * from invoice_det where id_inv = 10401,601,07

CREATE Function [dbo].[fBuscaPorcentagem_InlandFreight]--10401,601,07
(
	@id_inv	int,
	@InlandFreight float
)
returns float

as

begin
	Declare @Total as Float
--Declare @InlandFreight as Float

	Set @Total=(select sum(quantidade) from invoice_det where id_inv=@Id_inv)
	
Return @InlandFreight/@Total


end
GO
