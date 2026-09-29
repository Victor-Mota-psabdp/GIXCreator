SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[spARG_DocsEnviados_Sel]
(
@Email		varchar(100),
@Inicial	datetime,
@Final		datetime 
)
as
If @Email='EXISTE'
	Begin
		select 
			distinct(email) Email
		from
			doc_anexos DOC
			Join Pedido_Ship PS on PS.Num_Proc=DOC.Num_Proc
			Join Pedido P on P.Cd_Pedido=PS.Cd_Pedido
			Join Tipo_Doc_Cliente TDC on TDC.Id_DC=DOC.Id_DC
			Join Usuario_Cliente UC on UC.Cd_Usuario=P.Cd_CSRID -- CD_UserID
		where
			(Dt_Envio between @Inicial and @Final) and email is not null
	End
Else
	Begin
		select 
			distinct(DOC.Num_Proc ) JOB, Num_Pedido, Num_PO, Nome_DC--, email,dt_envio,P.CD_UserID,nome_usuario
		from
			doc_anexos DOC
			Join Pedido_Ship PS on PS.Num_Proc=DOC.Num_Proc
			Join Pedido P on P.Cd_Pedido=PS.Cd_Pedido
			Join Tipo_Doc_Cliente TDC on TDC.Id_DC=DOC.Id_DC
			Join Usuario_Cliente UC on UC.Cd_Usuario=P.Cd_CSRID -- CD_UserID
		where
			(Dt_Envio between @Inicial and @Final) and email=@Email
		order by 
			JOB 
	End	


--spARG_DocsEnviados_Sel 'sistemas@bdp.com.br','2008-10-31 08:00','2008-10-31 23:00'
--select * from tipo_doc_cliente
--select * from pedido
--select * from usuario_Cliente where cd_usuario='NG35767'
--select * from doc_anexos
--order by dt_envio














GO
