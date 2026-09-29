SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[spINTCustomerRepresentative]

		@Num_proc	varchar(16)

as

select US.Nome_usuario Usuario,CSr.Nome_Usuario CSR, PO.Nome_Usuario PO from pedido PD
left join usuario_cliente US on cd_userid=US.cd_usuario and us.nome_usuario not in ('SYS GEN','INCA DEFAULT','For SDN purposes, do not delet')
Left join Usuario_Cliente CSR on cd_csrid=CSR.cd_usuario and csr.nome_usuario not in ('SYS GEN','INCA DEFAULT','For SDN purposes, do not delet')
Left Join Usuario_Cliente PO on po_responsible=PO.cd_usuario and  po.nome_usuario not in ('SYS GEN','INCA DEFAULT','For SDN purposes, do not delet')
Left Join Pedido_Ship PS on PS.cd_pedido=PD.cd_pedido
where num_proc=@num_proc


GO
