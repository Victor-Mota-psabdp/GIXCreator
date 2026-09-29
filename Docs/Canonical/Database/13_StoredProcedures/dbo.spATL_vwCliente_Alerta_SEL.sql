SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spATL_vwCliente_Alerta_SEL]
@Field Varchar(250),
@Value  Varchar(250)
AS
if @Field ='MASTER'  
	begin 
		select * from vwCliente_Alerta where master = @Value
	end
if @Field ='HAWB' 
	begin 
		select * from vwCliente_Alerta where HAWB = @Value
	end	
if @Field ='NUM_PROC' 
	begin 
		select * from vwCliente_Alerta where num_proc = @Value
	end	

GO
