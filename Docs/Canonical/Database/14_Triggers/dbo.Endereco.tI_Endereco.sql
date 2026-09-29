SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger tI_Endereco on dbo.Endereco for INSERT as
/* ERwin Builtin Thu Dec 27 21:29:06 2001 */
/* INSERT trigger on Endereco */
begin
  declare  @numrows int,
           @nullcnt int,
           @validcnt int,
           @errno   int,
           @errmsg  varchar(255)
  select @numrows = @@rowcount
  /* ERwin Builtin Thu Dec 27 21:29:06 2001 */
  /* Tipo_Endereco R/15 Endereco ON CHILD INSERT RESTRICT */
  if
    /* update(Cd_Tp_End) */
    update(Cd_Tp_End)
  begin
    select @nullcnt = 0
    select @validcnt = count(*)
      from inserted,Tipo_Endereco
        where
          /* inserted.Cd_Tp_End = Tipo_Endereco.Cd_Tp_End */
          inserted.Cd_Tp_End = Tipo_Endereco.Cd_Tp_End
    /*  */
    
    if @validcnt + @nullcnt != @numrows
    begin
      select @errno  = 30002,
             @errmsg = 'Cannot INSERT Endereco because Tipo_Endereco does not exist.'
      goto error
    end
  end
  /* ERwin Builtin Thu Dec 27 21:29:06 2001 */
  return
error:
    raiserror @errno @errmsg
    rollback transaction
end

GO
ALTER TABLE [dbo].[Endereco] DISABLE TRIGGER [tI_Endereco]
GO
