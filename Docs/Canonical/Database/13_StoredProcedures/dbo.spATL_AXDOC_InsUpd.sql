SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_AXDOC_InsUpd]

@ID_AX	bigint	,
@Dimensao_1	varchar(40)	,
@Dimensao_2	varchar(40)	,
@Dimensao_3	varchar(40)	,
@Dimensao_4	varchar(40)	,
@Dimensao_5	varchar(40)	,
@Dimensao_6	varchar(40)	,
@Dimensao_7	varchar(40)	,
@Tipo	int	,
@NumeroInternoAX	varchar(50)	,
@Cd_Pessoa_AX	int	,
@AccountType	varchar(50)	,
@Aprovado	bit	,
@Aprovado_por	varchar(35)	,
@Data_Aprovação	datetime	,
@Company	varchar(3)	,
@Dt_Documento	datetime	,
@Numero_Documento	varchar(50)	,
@Dt_Vencimento	datetime	,
@Invoice_Number	varchar(50)	,
@TaxGroup	varchar(15)	,
@TaxItemGroup	varchar(15)	,
@Dt_Ins	datetime	,
@Dt_Envio_AX	datetime	,
@Obs_AX	varchar(500),
@ID_AX_Out int output	

AS
--Utilizado somente para o casos de Adto, onde o adiantamento foi cancelado e reenviado. Para diferenciar o numero da invoice no AX, é colocado um complemento
Declare @ComplementoNumeroInvoice Varchar(2) 
Declare @NumeroAdtos int 
SEt @ComplementoNumeroInvoice=''
if @Tipo=3
	Begin
		
		Set @NumeroAdtos=Isnull((select count(*) from ax_doc where left(invoice_number,20)=@Invoice_Number),0)
		if @NumeroAdtos<>0
			Begin
				Set @ComplementoNumeroInvoice=cast(@NumeroAdtos+1 as varchar(2))
			End
	End
if @Tipo=1 
	Begin
		if @Dt_Ins < '12-01-2013'
			Begin
				SEt @Dt_Envio_AX=@Dt_Ins
			End
	End

--FINAL
if @ID_AX is null
	Begin
		Insert
			AX_Doc	
				(
					
					Dimensao_1	,
					Dimensao_2	,
					Dimensao_3	,
					Dimensao_4	,
					Dimensao_5	,
					Dimensao_6	,
					Dimensao_7	,
					Tipo	,
					NumeroInternoAX	,
					Cd_Pessoa_AX	,
					AccountType	,
					Aprovado	,
					Aprovado_por	,
					Data_Aprovação	,
					Company	,
					Dt_Documento	,
					Numero_Documento	,
					Dt_Vencimento	,
					Invoice_Number	,
					TaxGroup	,
					TaxItemGroup	,
					Dt_Ins	,
					Dt_Envio_AX	,
					Obs_AX,
					ATIVO	
				)
				Values
				(
					
					@Dimensao_1	,
					@Dimensao_2	,
					@Dimensao_3	,
					Isnull(@Dimensao_4,'BRSAO')	,
					@Dimensao_5	,
					@Dimensao_6	,
					@Dimensao_7	,
					@Tipo	,
					@NumeroInternoAX	,
					@Cd_Pessoa_AX	,
					@AccountType	,
					@Aprovado	,
					@Aprovado_por	,
					@Data_Aprovação	,
					@Company	,
					@Dt_Documento	,
					@Numero_Documento	,
					@Dt_Vencimento	,
					@Invoice_Number+@ComplementoNumeroInvoice	,
					@TaxGroup	,
					@TaxItemGroup	,
					@Dt_Ins	,
					@Dt_Envio_AX	,
					@Obs_AX	,
					1

				)
				SEt @ID_AX_Out = (select MAX(id_ax) from AX_Doc)
				Update AX_DOC set Invoice_Number=cast(@ID_AX_OUT as varchar(50)) where id_Ax=@ID_AX_OUT and tipo=2
	End
Else
	Begin
			Update
				AX_Doc
			Set
			
				Dimensao_1	=	@Dimensao_1	,
				Dimensao_2	=	@Dimensao_2	,
				Dimensao_3	=	@Dimensao_3	,
				Dimensao_4	=	Isnull(Dimensao_4,'BRSAO')	,
				Dimensao_5	=	@Dimensao_5	,
				Dimensao_6	=	@Dimensao_6	,
				Dimensao_7	=	@Dimensao_7	,
				Tipo	=	@Tipo	,
				NumeroInternoAX	=	@NumeroInternoAX	,
				Cd_Pessoa_AX	=	@Cd_Pessoa_AX	,
				AccountType	=	@AccountType	,
				Aprovado	=	@Aprovado	,
				Aprovado_por	=	@Aprovado_por	,
				Data_Aprovação	=	@Data_Aprovação	,
				Company	=	@Company	,
				Dt_Documento	=	@Dt_Documento	,
				Numero_Documento	=	@Numero_Documento	,
				Dt_Vencimento	=	@Dt_Vencimento	,
				Invoice_Number	=	@Invoice_Number+@ComplementoNumeroInvoice	,
				TaxGroup	=	@TaxGroup	,
				TaxItemGroup	=	@TaxItemGroup	,
				Dt_Ins	=	@Dt_Ins	,
				Dt_Envio_AX	=	@Dt_Envio_AX	,
				Obs_AX	=	@Obs_AX	
			Where
					ID_AX	=	@ID_AX	
	
	End
	
	



GO
