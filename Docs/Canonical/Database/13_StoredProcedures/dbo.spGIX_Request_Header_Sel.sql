SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_help GIX_Request_Header
CReate procedure [dbo].[spGIX_Request_Header_Sel]
(
	@ID_Req				BigInt,	
	@UniqueMessageID	varchar(200),	
	@Customer			varchar(200),	
	@PrimaryKey			varchar(200),
	@SecondaryKey		varchar(200),	
	@SystemCode			varchar(200),
	@Tipo				char(1)
)
as

/*
A, /// Todos os registros - Existentes
B, /// Todos os registros - Ativos
C, /// Busca pelo Codigo - Existentes
D, /// Busca pelo Codigo - Ativos
N, /// Busca pelo Nome - Existentes
O /// Busca pelo Nome - Ativos
*/

if @Tipo = 'A' or @Tipo = 'B'
	Begin
		select 
			T.ID_Req,
			T.ControlNumber,
			T.UniqueMessageID,
			T.FromIdentifier,
			T.ToIdentifier,
			T.Customer,
			T.Timestamp,
			T.PrimaryKey,
			T.SecondaryKey,
			T.Header_Marks,
			T.Header_Type,
			T.Header_Action,
			T.Header_RequestType,
			T.DT_INS_PEDIDO,
			T.DT_INS_JOB,
			T.DT_INS_Nota_Cliente,
			T.SystemCode,
			T.Num_Proc,
			T.Utilizado,
			T.dt_ins,
			T.DT_INS_PESSOA,
			T.DT_INS_PRODUTO,
			T.DT_SEND_MESSAGE
		from 
			ATL_INT.dbo.GIX_Request_Header T with(nolock)	
		Where
			T.ID_Req = @ID_Req
	End


if @Tipo = 'C' or  @Tipo = 'D'
	Begin
		select 
			T.ID_Req,
			T.ControlNumber,
			T.UniqueMessageID,
			T.FromIdentifier,
			T.ToIdentifier,
			T.Customer,
			T.Timestamp,
			T.PrimaryKey,
			T.SecondaryKey,
			T.Header_Marks,
			T.Header_Type,
			T.Header_Action,
			T.Header_RequestType,
			T.DT_INS_PEDIDO,
			T.DT_INS_JOB,
			T.DT_INS_Nota_Cliente,
			T.SystemCode,
			T.Num_Proc,
			T.Utilizado,
			T.dt_ins,
			T.DT_INS_PESSOA,
			T.DT_INS_PRODUTO,
			T.DT_SEND_MESSAGE
		from 
			ATL_INT.dbo.GIX_Request_Header T with(nolock)	
		Where
			T.PrimaryKey = @PrimaryKey and SystemCode = @SystemCode
	End
	
if @Tipo = 'N' or  @Tipo = 'O'
	Begin
		select 
			T.ID_Req,
			T.ControlNumber,
			T.UniqueMessageID,
			T.FromIdentifier,
			T.ToIdentifier,
			T.Customer,
			T.Timestamp,
			T.PrimaryKey,
			T.SecondaryKey,
			T.Header_Marks,
			T.Header_Type,
			T.Header_Action,
			T.Header_RequestType,
			T.DT_INS_PEDIDO,
			T.DT_INS_JOB,
			T.DT_INS_Nota_Cliente,
			T.SystemCode,
			T.Num_Proc,
			T.Utilizado,
			T.dt_ins,
			T.DT_INS_PESSOA,
			T.DT_INS_PRODUTO,
			T.DT_SEND_MESSAGE
		from 
			ATL_INT.dbo.GIX_Request_Header T with(nolock)	
		Where
			T.Customer = @Customer and SystemCode = @SystemCode
	End
	


GO
